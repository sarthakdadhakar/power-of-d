# 0. Setup:
## Smit :

    bash ~/CLionProjects/novalsm-group/scripts/bootstrap/env/setup-apt-ssh.sh 5 smit14 ~/CLionProjects/novalsm-group ~/CLionProjects/novalsm-group/cmake-build-debug dev nova-lsm copy

## Hitarth :

    bash ./scripts/bootstrap/env/setup-apt-ssh.sh 5 kanakia ./ ./cmake-build-debug dev novalsm copy

## Dhrumil

    bash ~/CLionProjects/novalsm-group/scripts/bootstrap/env/setup-apt-ssh.sh 5 dhrumil ~/CLionProjects/novalsm-group ~/CLionProjects/novalsm-group/cmake-build-debug dev rangepartition copy

# 2. SSH:
## Smit

    clssh 0
## Hitarth

    clssh 0 kanakia dev novalsm
## Dhrumil

    clssh 0 dhrumil dev rangepartition

# 2. Copy:
## nova_server_main :

## jar files :

    bash scripts/copy_files.sh 5 dhrumil "/home/smit/IdeaProjects/NovaLSM-YCSB-Client/out/artifacts/*jar" /users/dhrumil/nova dev rangepartition

## local_copy_exp :

## config :

# 2. Kill all:

# 3. Run tutorial experiment on server (from node-0)

## Hitarth
    bash scripts/local_copy_nova_lsm_tutorial.sh kanakia run_backup
    
# 4. Adhoc copying
## Hitarth
    ./scripts/copy_files.sh 5 kanakia ../../IdeaProjects/NovaLSM-YCSB-Client/out/artifacts/nova_client_stats_jar/nova_client_stats.jar /users/kanakia/nova dev novalsm &&
    ./scripts/copy_files.sh 5 kanakia ../../IdeaProjects/NovaLSM-YCSB-Client/out/artifacts/nova_coordinator_jar/nova_coordinator.jar /users/kanakia/nova dev novalsm &&
    ./scripts/copy_files.sh 5 kanakia ./scripts/tutorial/local_copy_nova_lsm_tutorial.sh /users/kanakia/scripts dev novalsm &&
    ./scripts/copy_files.sh 5 kanakia ./scripts/tutorial/nova_lsm_tutorial_backup.sh /users/kanakia/scripts dev novalsm &&
    ./scripts/copy_files.sh 5 kanakia ./scripts/tutorial/nova_lsm_tutorial_exp.sh /users/kanakia/scripts dev novalsm &&
    ./scripts/copy_files.sh 5 kanakia ./config/nova-tutorial-config /users/kanakia/config dev novalsm &&
    ./scripts/copy_files.sh 5 kanakia ./cmake-build-release-wsl/nova_server_main /users/kanakia/nova dev novalsm
    
## Dhrumil
    
# 5. dos2unix
    find . -type f -print0 | xargs -0 dos2unix