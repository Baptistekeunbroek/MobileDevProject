# Project TechToTech Security Event App
# Mobile development IOS


## Version 
1.0

## Requirements

- Xcode 6.0 or later (download it for free from the Mac App Store)
- iOS 8.0 or later

## Description
As the iOS development team at TechToTech agency, we created a mobile application for our client's next event. The event is a 2-day security conference. During these 2 days, there will be several types of conferences and activities spread over several rooms. This application will make it easier for visitors to find their way around the event, with all schedules and information on their cell phone. 

## Launch the project 

### 1. Download or clone the project from GitHub

- Use the command `git clone` :  git clone https://github.com/username/project-name.git
- Download zip files 

### 2. Open Xcode application

### 3. Open the project in Xcode and configure

- Select "Open another project..." from the welcome screen.
- Navigate to the cloned project directory and select the file with the extension ".xcodeproj" or ".xcworkspace".
- Choose the simulator or device on which you wish to run the application.

### 4. Configuration 

Our project use an API database on Airtable, it is necessary to create an API token on Airtable and add it in Xcode to access the data. 

- Create an account or log in to your Airtable account : https://airtable.com.
- Access the database on this link : https://airtable.com/invite/l?inviteId=invuNxfa8nluUqZrl&inviteToken=2dbeb383130a580c5dc606319cdb4491ecc3983d9b2357b57fd6c0e3fae49388&utm_medium=email&utm_source=product_team&utm_content=transactional-alerts
- Go to Accounts, then Developer Spaces. Click on the "Create Token" button.
- Copy the generated token.
- Add the token to your Xcode project by clicking on "Edit Scheme..." then select "Environment variables". 
- Put `AIRTABLE_API_KEY` for the name and past the token for the value. 

### 4. Run the project

- Now, press the play button to compile and run the project.
- See the results with the simulator or a real device with the application running.
