#!/bin/bash
# Jenkins Setup and Configuration Script
# This script helps you set up Jenkins with Docker agents

set -e

echo "================================================"
echo "Jenkins Setup Script"
echo "================================================"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${YELLOW}$1${NC}"
    echo "================================================"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_header "Step 1: Building Jenkins Image"
docker build -t jenkins-custom:latest .
print_success "Jenkins image built successfully"

print_header "Step 2: Starting Jenkins and Agents"
docker-compose up -d
print_success "Jenkins container started"
sleep 10

print_header "Step 3: Getting Jenkins Initial Password"
JENKINS_PASSWORD=$(docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || echo "NOT_FOUND")

if [ "$JENKINS_PASSWORD" != "NOT_FOUND" ]; then
    print_success "Jenkins Initial Admin Password: $JENKINS_PASSWORD"
    echo ""
    echo "Access Jenkins at: http://localhost:8080"
    echo "Username: admin"
    echo "Password: $JENKINS_PASSWORD"
else
    print_error "Could not retrieve initial password"
    echo "Check logs with: docker logs jenkins"
fi

print_header "Step 4: Waiting for Jenkins to be Ready"
for i in {1..30}; do
    if docker exec jenkins curl -s http://localhost:8080 > /dev/null 2>&1; then
        print_success "Jenkins is ready!"
        break
    fi
    echo "Waiting... ($i/30)"
    sleep 5
done

print_header "Step 5: Configure Jenkins Agents"
echo ""
echo "To connect Docker agents to Jenkins:"
echo "1. Go to http://localhost:8080"
echo "2. Navigate to: Manage Jenkins > Security > Manage users (setup admin user)"
echo "3. Create SSH key for Jenkins:"
echo "   - Run: ssh-keygen -t rsa -b 4096 -f jenkins_agent_key -N ''"
echo "4. Add public key to Jenkins:"
echo "   - Manage Jenkins > Credentials > System > Add Credentials"
echo "   - Kind: SSH Username with private key"
echo "   - Username: jenkins"
echo "   - Enter the private key content from jenkins_agent_key"
echo ""
echo "5. For each agent (agent-docker-1 and agent-docker-2):"
echo "   - Go to Manage Jenkins > Nodes"
echo "   - Click 'New Node'"
echo "   - Name: agent-docker-1 (or agent-docker-2)"
echo "   - Type: Permanent Agent"
echo "   - Configure:"
echo "     - Remote root directory: /home/jenkins/agent"
echo "     - Labels: docker docker-1 (for agent-docker-1)"
echo "     - Launch method: Launch agents via SSH"
echo "     - Host: jenkins_agent_1 (or jenkins_agent_2)"
echo "     - Credentials: Select the SSH key you created"
echo "     - Host Key Verification Strategy: Non verifying Verification Strategy"
echo ""

print_header "Step 6: Install Required Plugins"
echo "After logging in, go to:"
echo "- Manage Jenkins > Plugins > Available Plugins"
echo "- Search and install:"
echo "  * Docker Pipeline"
echo "  * Docker"
echo "  * Pipeline"
echo "  * Git"
echo "  * GitHub"
echo "  * Blue Ocean"
echo ""

print_header "Docker Compose Status"
docker-compose ps

print_success "Jenkins setup complete!"
echo ""
echo "Next steps:"
echo "1. Access Jenkins at http://localhost:8080"
echo "2. Complete initial setup with admin password above"
echo "3. Install plugins"
echo "4. Configure agents"
echo "5. Create your pipeline job"
