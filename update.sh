if [ $# -ne 1 ]; then
    echo $0: usage: update.sh NODE_RED_VERSION
    exit 1
fi

NODE_RED_VERSION=$1

sed -i "" -e "s/\(version\": \"\).*\(\"\)/\1$NODE_RED_VERSION\"/g" package.json
sed -i "" -e "s/\(node-red\": \"\).*\(\"\)/\1$NODE_RED_VERSION\"/g" package.json
