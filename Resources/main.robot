*** Settings ***
Documentation       Main resource file. Contains imports for all resource files, POM files, and Component Files. Is the base import for all other resource files.
Library             SeleniumLibrary
Library             String
Library             Collections
Resource            POM/pom_BasePage.robot
Resource            POM/pom_PasswordGenerator.robot
Resource            setup.robot