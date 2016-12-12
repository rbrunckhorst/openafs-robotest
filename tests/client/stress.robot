# Copyright (c) 2015 Sine Nomine Associates
# Copyright (c) 2001 Kungliga Tekniska Högskolan
# See LICENSE

*** Settings ***
Documentation     Client stess tests
Resource          openafs.robot

*** Test Cases ***
Create a Large Number of Entries in a Directory
    [Tags]  slow  #(too-many-files)
    Create Files  ${RWPATH}  31707  0

Write a File, Read, Rewrite and Reread a File with the Same Open Descriptor
    [Tags]  todo  #(read-write)
    TODO

Populate and Clean up a Directory Tree
    [Tags]  todo  #(create-remove-files)
    TODO

FSX File System Stresser
    [Tags]  todo  #(fsx)
    TODO

Create and Remove a Single File in Parallel
    [Tags]  todo  #(parallel1)
    TODO

