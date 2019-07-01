export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="/Users/deppa/workspace-git/terraform-wrapper/bin:$PATH"

#Load variable for virtualenv python
source /usr/local/bin/virtualenvwrapper.sh

#Active aws virtualenv
workon aws3

#Export pass folder
export PASSWORD_STORE_DIR=/Users/deppa/workspace/xpeppers/xpeppers-keys-password

#Avoid ansible check hosting
export ANSIBLE_HOST_KEY_CHECKING=False

alias ll='ls -a -l -G "$@"'
alias grep='/usr/bin/grep --colour=always "$@"'
alias ora='date +%X'
alias cat='/usr/local/bin/lolcat'
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
alias awsregionlist='echo -e "us-east-1\nus-east-2\nus-west-1\nus-west-2\nap-northeast-2\nap-southeast-1\nap-southeast-2\nap-northeast-1\neu-central-1\neu-west-1\neu-west-2"'
alias gitlab-create='python ~/workspace/gitlab/create-project/create-project.py "$@"'
alias w='cd ~/workspace'
alias update_mac='ansible-playbook ~/mac-dev-playbook/main.yml -i ~/mac-dev-playbook/inventory -K'
alias remove-ami='~/workspace/tools/aws/remove-ami.sh "$@"'
alias verdone="open -a /Applications/Google\ Chrome.app https://www.youtube.com/watch\?v\=BF56TzwEt-g\#t\=0m48s"
alias noncapisconoun="open -a /Applications/Google\ Chrome.app https://www.youtube.com/watch\?v\=ZwH9Dkv3s_s\#t\=1m0s"
alias terraform="~/terraform-bin/terraform-0.11.13"
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
#avoid to change tab name
#http://superuser.com/questions/343747/how-do-i-stop-automatic-changing-of-iterm-tab-titles
export TERM=xterm

export aws_region_list=(us-east-2 us-east-1 us-west-1 us-west-2 ap-south-1 ap-northeast-3 ap-northeast-2 ap-southeast-1 ap-southeast-2 ap-northeast-1 ca-central-1 cn-north-1 cn-northwest-1 eu-central-1 eu-west-1 eu-west-2 eu-west-3 eu-north-1 sa-east-1 us-gov-east-1 us-gov-west-1)

function setup_aws_credentials() {
    profile_name=$1
    role_arn=`/usr/bin/grep -A4 "\[$profile_name\]" ~/.aws/credentials|/usr/bin/grep role_arn|sed 's/^.*arn:/arn:/g'`
    local stscredentials
    stscredentials=$(aws sts assume-role \
        --profile $profile_name \
        --role-arn "${role_arn}" \
        --role-session-name something \
        --query '[Credentials.SessionToken,Credentials.AccessKeyId,Credentials.SecretAccessKey]' \
        --output text)

    AWS_ACCESS_KEY_ID=$(echo "${stscredentials}" | awk '{print $2}')
    AWS_SECRET_ACCESS_KEY=$(echo "${stscredentials}" | awk '{print $3}')
    AWS_SESSION_TOKEN=$(echo "${stscredentials}" | awk '{print $1}')
    AWS_SECURITY_TOKEN=$(echo "${stscredentials}" | awk '{print $1}')

    region=$(/usr/bin/grep -A4 "\[$profile_name\]" ~/.aws/credentials|/usr/bin/grep region|sed s/'.*=[ ]'//g)
    if [ $region ]
    then
        AWS_DEFAULT_REGION=$region
        export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN AWS_DEFAULT_REGION
    else
        export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN
    fi

}

function synctos3()
{
/Users/deppa/.virtualenvs/aws/bin/aws s3 sync --profile daniel-workspace-backup --storage-class STANDARD_IA ~/workspace s3://workspace-daniel/workspace
/Users/deppa/.virtualenvs/aws/bin/aws s3 sync --profile daniel-workspace-backup --storage-class STANDARD_IA ~/workspace-claranet s3://workspace-daniel/workspace-claranet
/Users/deppa/.virtualenvs/aws/bin/aws s3 sync --profile daniel-workspace-backup --storage-class STANDARD_IA ~/workspace-git s3://workspace-daniel/workspace-git
/Users/deppa/.virtualenvs/aws/bin/aws s3 sync --profile daniel-workspace-backup --storage-class STANDARD_IA ~/workspace-personale s3://workspace-daniel/workspace-personale
}

sync_to_disco_dati()
{
rsync -va --progress ~/workspace-personale /Volumes/discodati
rsync -va --progress ~/workspace /Volumes/discodati
rsync -va --progress ~/workspace-claranet /Volumes/discodati
}

unset_aws_credentials()
{
unset AWS_ACCESS_KEY_ID
unset AWS_SESSION_TOKEN
unset AWS_SECRET_ACCESS_KEY
unset AWS_SECURITY_TOKEN
unset AWS_DEFAULT_REGION
}

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

mkdir -p /Users/deppa/.local/share/
mkdir -p /Users/deppa/.local/share/autojump/
