# woot-deals

### Overview
   - Hello! This repo contains the files to my woot-deals project. This project was inspired by my sister wanting airpods. She was manually checking the site for these everyday and I thought I could help her out. 
   - The python script sends a request to woot.com for its daily deals. This request is fronted in the dev tools console. The script parses through the response and only grabs the information I found necessary (Item category and name). 
   - I manage the infrastructure via terraform under the terraform/ directory. 
   - It is a lambda that is triggered by a cloudwatch event. This event triggers every morning at 7am CST. 
