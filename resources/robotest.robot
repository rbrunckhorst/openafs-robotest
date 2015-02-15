# Copyright (c) 2014, Sine Nomine Associates
# See LICENSE

*** Settings ***
Documentation     Import common keywords and variables for
...               the OpenAFS test suite.
Library           OperatingSystem
Library           String
Library           OpenAFS
Library           Kerberos
Resource          prechecks.robot
Resource          install.robot
Resource          newcell.robot
Variables         sysinfo.py
Variables         platforms/${AFS_DIST}.py

*** Keywords ***
Command Should Succeed
    [Arguments]  ${cmd}  ${msg}=None
    ${rc}  ${output}  Run And Return Rc And Output  ${cmd}
    Should Be Equal As Integers  ${rc}  0
    ...  msg=${msg}: ${cmd}, rc=${rc}, ${output}
    ...  values=False

Command Should Fail
    [Arguments]  ${cmd}
    ${rc}  ${output}  Run And Return Rc And Output  ${cmd}
    Should Not Be Equal As Integers  ${rc}  0
    ...  msg=Should have failed: ${cmd}
    ...  values=False

Run Command
    [Arguments]  ${cmd}
    ${rc}  ${output}  Run And Return Rc And Output    ${cmd}
    Should Be Equal As Integers  ${rc}  0
    ...  msg=Failed: ${cmd}, rc=${rc}, ${output}
    ...  values=False

Sudo
    [Arguments]  ${cmd}  @{args}
    ${arg}  Catenate  @{args}
    Run Command  sudo -n ${cmd} ${arg}

Should Be File
    [Arguments]  ${path}
    Should Exist     ${path}
    Should Be True   os.path.isfile("${path}")
    ...  msg=${path} is not a file.

File Should Be Executable
    [Arguments]  ${file}
    Should Not Be Empty  ${file}
    Should Be File  ${file}
    Should Be True  os.access("${file}", os.X_OK)
    ...  msg=${file} is not executable.

Should Be Symlink
    [Arguments]  ${path}
    Should Exist    ${path}
    Should Be True  os.path.islink("${path}")
    ...  msg=${path} is not a symlink.

Should Not Be Symlink
    [Arguments]  ${path}
    Should Exist        ${path}
    Should Not Be True  os.path.islink("${path}")
    ...  msg=${path} is a symlink.

Should Be Dir
    [Arguments]  ${path}
    Should Exist     ${path}
    Should Be True   os.path.isdir("${path}")
    ...  msg=${path} is not a directory.

Should Not Be Dir
    [Arguments]  ${path}
    Should Exist         ${path}
    Should Not Be True   os.path.isdir("${path}")
    ...  msg=${path} is a directory.

Link Count Should Be
    [Arguments]  ${path}  ${count}
    Should Exist    ${path}
    Should Be True  os.stat("${path}").st_nlink == ${count}
    ...  msg=${path} does not have ${count} links.

Inode Should Be Equal
    [Arguments]  ${a}  ${b}
    Should Exist  ${a}
    Should Exist  ${b}
    Should Be True  os.stat("${a}").st_ino == os.stat("${b}").st_ino
    ...  msg=${a} and ${b} do not have the same inode number.

Get Inode
    [Arguments]  ${path}
    ${inode}=  Evaluate  os.stat("${path}").st_ino  os
    [Return]  ${inode}

Start Service
    [Arguments]  ${name}
    Should Not Be Empty  ${name}
    Sudo  /sbin/service ${name} start

Stop Service
    [Arguments]  ${name}
    Should Not Be Empty  ${name}
    Sudo  /sbin/service ${name} stop

Program Should Be Running
    [Arguments]  ${program}
    ${output}=  Run   ps -ef
    Should Contain  ${output}  ${program}  msg=Program ${program} is not running!  values=False

Program Should Not Be Running
    [Arguments]  ${program}
    ${output}=  Run   ps -ef
    Should Not Contain  ${output}  ${program}  msg=Program ${program} is running!  values=False

Rx Service Should Be Reachable
    [Arguments]  ${host}  ${port}
    Run Command  ${RXDEBUG} ${host} ${port} -version

Login
    [Arguments]  ${name}
    Should Not Be Empty  ${name}
    # Convert OpenAFS k4 style names to k5 style principals.
    ${principal}=  Replace String  ${name}  .  /
    ${keytab}=  Set Variable If  "${name}"=="${AFS_USER}"    ${KRB_USER_KEYTAB}
    ${keytab}=  Set Variable If  "${name}"=="${AFS_ADMIN}"   ${KRB_ADMIN_KEYTAB}
    File Should Exist   ${keytab}
    Remove File  site/krb5cc
    Run Command  KRB5CCNAME=site/krb5cc ${KINIT} -5 -k -t ${keytab} ${principal}@${KRB_REALM}
    Run Command  KRB5CCNAME=site/krb5cc ${AKLOG} -d -c ${AFS_CELL} -k ${KRB_REALM}

Logout
    Run Command  KRB5CCNAME=site/krb5cc ${KDESTROY}
    Run Command  ${UNLOG}

Create Volume
    [Arguments]  ${server}  ${part}  ${name}
    Run Command  ${VOS} create -server ${server} -partition ${part} -name ${name} -verbose

Remove Volume
    [Arguments]  ${name}
    Run Command  ${VOS} remove -id ${name}

Mount Volume
    [Arguments]  ${dir}  ${vol}  @{options}
    ${opts}  Catenate  @{options}
    Run Command  ${FS} mkmount -dir ${dir} -vol ${vol} ${opts}

Remove Mount Point
    [Arguments]  ${dir}
    Run Command  ${FS} rmmount -dir ${dir}

Add Access Rights
    [Arguments]  ${dir}  ${group}  ${rights}
    Run Command  ${FS} setacl -dir ${dir} -acl ${group} ${rights}

Replicate Volume
    [Arguments]    ${server}  ${part}  ${volume}
    Run Command    ${VOS} addsite -server ${server} -part ${part} -id ${volume}
    Run Command    ${VOS} release -id ${volume} -verbose
