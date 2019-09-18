# Install Python 3
if [[ ${TAG_SUFFIX} == "default" ]]; then
  echo "Installing Python 3"
  apk add --no-cache python
else
  echo "Skip installing Python 3"
fi
