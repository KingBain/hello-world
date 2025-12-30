#!/bin/bash
set -e

echo "Setting up Apko and Melange wrappers..."

# 1. Pull the official images to ensure they are ready in the cache
docker pull cgr.dev/chainguard/apko:latest
docker pull cgr.dev/chainguard/melange:latest

# 2. Create the 'apko' wrapper script
# We mount the current directory (${PWD}) to /work inside the container
sudo tee /usr/local/bin/apko > /dev/null <<EOF
#!/bin/bash
docker run --rm -v "\${PWD}:/work" -w /work cgr.dev/chainguard/apko:latest "\$@"
EOF

# 3. Create the 'melange' wrapper script
# Melange requires --privileged to perform build operations (bubblewrap/nested containers)
sudo tee /usr/local/bin/melange > /dev/null <<EOF
#!/bin/bash
docker run --privileged --rm -v "\${PWD}:/work" -w /work cgr.dev/chainguard/melange:latest "\$@"
EOF

# 4. Make them executable
sudo chmod +x /usr/local/bin/apko
sudo chmod +x /usr/local/bin/melange

echo "Setup complete! You can now use 'apko', 'melange', and 'cosign'."