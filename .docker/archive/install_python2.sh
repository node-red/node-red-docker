# Install Python 2
if [[ ${TAG_SUFFIX} == "default" ]]; then
  echo "Installing Python 2"
  apk add --no-cache python
else
  echo "Skip installing Python 2"
fi
