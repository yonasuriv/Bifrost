<p align="center"><img width="100"src="https://github.com/yonasuriv/bifrost/assets/59540565/f54a434f-6c66-4d0c-8962-97bd2a62d16a"></a></p>
<p align="center"><img width="500"src="https://github.com/yonasuriv/bifrost/assets/59540565/f24d0614-0d62-4d74-a5af-a1456b9cca24"></a></p>


## About
Bifrost Link 🔗 is an application written mainly in [Shell](https://en.wikipedia.org/wiki/Shell_script) and delivered as a single executable.

The approach of this project is to make the Penetration Testing work more efficient by Autimation and to also be used as a Training Tool for various platforms such as [HackTheBox](https://www.hackthebox.com/), [TryHackMe](https://tryhackme.com/) and other Playgrounds as well as for the preparation for various certifications related to cybersecurity. 
 
Depending on the interactions between services and source or destination of traffic, rules are created and sorted by assignment.

## Distribution
Stable-Experimental: Bifrost Link is currently under Development.

## Installation

```bash
git clone https://github.com/yonasuriv/bifrost.git > /dev/null 2>&1 && 
cd bifrost
sh BuildBifrostBridge 
cd - > /dev/null 2>&1
```

## Run
Simply run the command ```bifrost```<br>

**It is highly recommended to install the dependencies before running the program.**

You can do it by running ```bifrost -X```

This will automatically install everything.<br>

You can either choose _normal_ or _debug mode_.<br>

Where in **normal** the output won't be shown, only the name of the package being installed/updated _(fastest)_.

## Start a New Project

Without giving it any arguments it will automatically create a **temporary** project to work on, which will be deleted the next time Bifrost is run again.

* Use ```bifrost -p``` to bring up the projects menu or simply 
* Use ```bifrost -p <PROJECT NAME>``` to create it and switch to it immediately.<br>

## Contribution
Want to contribute? Awesome!<br> 
The most basic way to show your support is to  **Star** ⭐ the project or to **Raise Issues** 🚩. <br>
You can also support this project by suggesting any _change/update/upgrade/feature_ 🙏

## Authors
* **Jonathan Di Rico** - **WithSecure** (F-Secure) Cyber Defence Service

## Documentation

* See [Gallery](https://github.com/yonasuriv/Bifrost/blob/main/docs/Gallery.md) for images

* See ```bifrost -H``` for more details

## Acknowledgements
* See ```CREDITS``` for more details.

## License
* See ```LICENSE``` for more details. [MIT]

