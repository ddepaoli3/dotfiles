export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#Load variable for virtualenv python
source /usr/local/bin/virtualenvwrapper.sh

#Active aws virtualenv
workon aws

#Export pass folder
export PASSWORD_STORE_DIR=/Users/deppa/workspace/gitlab/xpeppers-keys-password

alias ll='ls -a -l -G "$@"'
alias grep='/usr/bin/grep --colour=always "$@"'
alias ora='date +%X'
alias copysshkey='cat $HOME/.ssh/id_rsa.pub | pbcopy'
alias chname='export PS1="\h:'$@'$ "'
alias json_yaml_tool='/Users/deppa/.virtualenvs/aws/bin/python /Users/deppa/workspace/tools/json_yaml_tools/json-yaml.py $@'
alias xpeppersssh='ssh -i ~/keys/xpeppers/xpeppers.pem ubuntu@54.77.239.161'
alias ec2_list='/Users/deppa/.virtualenvs/aws/bin/python /Users/deppa/workspace/tools/aws/instances_table.py "$@"'
alias rds_list='/Users/deppa/.virtualenvs/aws/bin/python /Users/deppa/workspace/tools/aws/rds_list.py "$@"'
alias ssh='/usr/bin/ssh -o ServerAliveInterval=100 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$@"'
alias random_string='cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1'
alias password_gen='openssl rand -base64 "$@"'
alias codecommittool='bash ~/workspace/gist/create-codecommit-repo.sh "$@"'
alias synctos3='/Users/deppa/.virtualenvs/aws/bin/aws s3 sync --profile daniel --storage-class STANDARD_IA ~/workspace s3://workspace-xpeppers'
alias awsregionlist='echo -e "us-east-1\nus-east-2\nus-west-1\nus-west-2\nap-northeast-2\nap-southeast-1\nap-southeast-2\nap-northeast-1\neu-central-1\neu-west-1\neu-west-2"'
alias gitlab-create='python ~/workspace/gitlab/create-project/create-project.py "$@"'
alias w='cd ~/workspace'
alias update_mac='ansible-playbook ~/mac-dev-playbook/main.yml -i ~/mac-dev-playbook/inventory -K'
#avoid to change tab name
#http://superuser.com/questions/343747/how-do-i-stop-automatic-changing-of-iterm-tab-titles
export TERM=xterm

ec2_list_aws()
{
aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId,InstanceType,State.Name,PrivateIpAddress,PublicIpAddress,Tags[?Key=='Name'] | [0].Value]" --output table --filters Name=instance-state-name,Values=running --profile "$@"
}

clear ()
{
echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
/usr/bin/clear
}

folder_tree ()
{
rm /Users/deppa/foldertree.json
tree -d -f -o foldertree.json  -J /Users/deppa/
git checkout folder
git add -f foldertree.json
git commit -m "Folder tree of day `date +%F`"
git checkout master
}

title ()
{
    echo -ne "\033]0;"$*"\007"
}

backup_workspace()
{
if [[ $(mount|grep CHIAVI) ]]
then
    cd ~
    tar -cf - workspace|gpg -o /Volumes/CHIAVI/workspace-backup/workspace-`date +%y%m%d`.tar.gz.gpg --encrypt --recipient "Daniel Depaoli"
else
    echo "CHIAVI not mounted. No backup"
fi
}

[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
