!/bin/bash
# lines that start like this are shell comments
# read projects current directory with $PWD
./apollo-ios-cli generate

echo "running command from" $PWD
# cd ..
cd $PWD
cd SpaceXAPI
echo "running command from" $PWD
git add .
git remote add origion https://github.com/pratikpanchal-techholding/SpaceXAPI_ApolloGraphQL_iOS.git
git status
echo "Query Params Update"
git commit -m "Query Params Updated"
git push

