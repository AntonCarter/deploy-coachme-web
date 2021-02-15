cmd="up"
octopus=0
project_name="Merit"
deploy_environment="dev"
while getopts ":n:c:o:e:" opt; do
	case $opt in
		o) octopus=1 ;;
		n) project_name="$OPTARG" ;;
		c) cmd="$OPTARG" ;;
		e) deploy_environment="$OPTARG" ;;
		\?) echo "Invalid option -$OPTARG" >&2 ;;
	esac
done

echo Deploy Environment is "$deploy_environment"

if [[ $cmd = "up" ]]; then
	if [[ octopus -eq 1 ]]; then
		echo "Replacing '.env' file with 'octopus.env'"
		mv ./.env ./.env.old
		mv ./octopus.env ./.env
	fi
	echo 'project name $projectname'
	echo '--------------'
	echo 'deployment variables'
	echo '--------------'
	cat docker-compose.yml
	echo '--------------'
	
	docker stack deploy --with-registry-auth --compose-file docker-compose.yml coachme-web-$deploy_environment 2>&1
else
	docker-compose --project-name $project_name $cmd -d 2>&1
fi
