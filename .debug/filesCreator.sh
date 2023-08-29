# C with "Hello, World!"
echo "#include <stdio.h>

int main() {
    printf(\"Hello, World!\\n\");
    return 0;
}" > C.c

# C++ with "Hello, World!"
echo "#include <iostream>

int main() {
    std::cout << \"Hello, World!\" << std::endl;
    return 0;
}" > C++.cpp

# Java with "Hello, World!"
echo "public class Java {
    public static void main(String[] args) {
        System.out.println(\"Hello, World!\");
    }
}" > Java.java

# Python with "Hello, World!"
echo "print(\"Hello, World!\")" > Python.py

# JavaScript with "Hello, World!"
echo "console.log('Hello, World!');" > JavaScript.js

# Ruby with "Hello, World!"
echo "puts 'Hello, World!'" > Ruby.rb

# Perl with "Hello, World!"
echo "print \"Hello, World!\\n\";" > Perl.pl

# PHP with "Hello, World!"
echo "<?php
echo \"Hello, World!\\n\";
?>" > PHP.php

# Swift with "Hello, World!"
echo "print(\"Hello, World!\")" > Swift.swift

# Kotlin with "Hello, World!"
echo "fun main() {
    println(\"Hello, World!\")
}" > Kotlin.kt

# Go with "Hello, World!"
echo "package main

import \"fmt\"

func main() {
    fmt.Println(\"Hello, World!\")
}" > Go.go

# Rust with "Hello, World!"
echo "fn main() {
    println!(\"Hello, World!\");
}" > Rust.rs

# Scala with "Hello, World!"
echo "object Scala {
  def main(args: Array[String]): Unit = {
    println(\"Hello, World!\")
  }
}" > Scala.scala

# Dart with "Hello, World!"
echo "void main() {
  print('Hello, World!');
}" > Dart.dart

# R with "Hello, World!"
echo "cat(\"Hello, World!\\n\")" > R.R

# MATLAB with "Hello, World!"
echo "fprintf('Hello, World!\\n');" > MATLAB.m

# SQL (empty file)
touch SQL.sql

# SQL (empty file)
touch SQL.sql

# Dart with "Hello, World!"
echo "void main() {
  print('Hello, World!');
}" > Dart.dart

# R with "Hello, World!"
echo "cat(\"Hello, World!\\n\")" > R.R

# MATLAB with "Hello, World!"
echo "fprintf('Hello, World!\\n');" > MATLAB.m

# Julia with "Hello, World!"
echo 'println("Hello, World!")' > Julia.jl

# TypeScript with "Hello, World!"
echo 'console.log("Hello, World!");' > TypeScript.ts

# Lua with "Hello, World!"
echo 'print("Hello, World!")' > Lua.lua

# Haskell with "Hello, World!"
echo 'main = putStrLn "Hello, World!"' > Haskell.hs

# Groovy with "Hello, World!"
echo 'println "Hello, World!"' > Groovy.groovy

# Fortran with "Hello, World!"
echo 'program HelloWorld
  print *, "Hello, World!"
end program HelloWorld' > Fortran.f90

# SQL (empty file)
touch SQL.sql

# Dart with "Hello, World!"
echo "void main() {
  print('Hello, World!');
}" > Dart.dart

# R with "Hello, World!"
echo "cat(\"Hello, World!\\n\")" > R.R

# MATLAB with "Hello, World!"
echo "fprintf('Hello, World!\\n');" > MATLAB.m

# Julia with "Hello, World!"
echo 'println("Hello, World!")' > Julia.jl

# TypeScript with "Hello, World!"
echo 'console.log("Hello, World!");' > TypeScript.ts

# Lua with "Hello, World!"
echo 'print("Hello, World!")' > Lua.lua

# Haskell with "Hello, World!"
echo 'main = putStrLn "Hello, World!"' > Haskell.hs

# Groovy with "Hello, World!"
echo 'println "Hello, World!"' > Groovy.groovy

# Fortran with "Hello, World!"
echo 'program HelloWorld
  print *, "Hello, World!"
end program HelloWorld' > Fortran.f90

# C#
echo 'using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Hello, World!");
    }
}' > CSharp.cs

# Assembly
echo '.global _start

section .data
    hello db "Hello, World!", 0

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, hello
    mov rdx, 13
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall' > Assembly.asm
