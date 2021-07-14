# No Sleep

• An Integration of Amazon Rekognition and Flutter for Tracking Drivers’ Eyes.


# I. Description of the Selected Problem:
• Each year, nearly 100,000 traffic crashes can be attributed to drowsy driving, including more than 1,500 deaths and over 70,000 injuries according to the <ins>**U.S.**</ins> National Highway Traffic Safety Administration. Most drowsy driving accidents occur between midnight and 6 a.m. among drivers who are alone in their vehicles (Medicalxpress.com, 2018). So, I tried to solve this problem by myself. The Application is developed using Amazon Rekognition for detecting whether “EyesOpen” is True or False.


# II. What the Application does:
• It detects drivers’ eyes as if they slept while driving, a sound and vibration will start to play until he wakes up.
  

# III. How it works:
• The Application lets the device’s camera capture an image each few seconds and save it locally in the device, sending this image’s <ins>**bytes**</ins> to Rekognition’s API, and then I get the response as a JSON file. If the Confidence for that a Face is included in the image more than 98, and the Value for the **EyesOpen** is False, then an alert will start to play and vibration will happen. Then, the image will be deleted from the device to prevent huge storage usage. Once the driver has opened his eyes, the sound and vibration will stop automatically. This process happens whenever the Application is opened. The Application uses Wakelock Package to prevent the device from sleeping. 

<ins>**Note:**</ins> A delay may happen when the driver wakes up and the sound/vibration waits a few seconds to stop, for that case, I have implemented that if the driver touched the Application anywhere, any sound/vibration will be force stopped.


# IV. Performance/Monitoring:
  **Performance measured by using Flutter DevTools (Flutter run -- profile)**
  
**• Network/Requests:**

<img width="816" alt="Network" src="https://user-images.githubusercontent.com/66283081/119617988-ae650480-be02-11eb-8db3-908dc796a79f.png">


**• Memory:**

<img width="1670" alt="Memory" src="https://user-images.githubusercontent.com/66283081/119617994-b0c75e80-be02-11eb-8384-579641f07c6b.png">


**• Logs:**

<img width="1647" alt="Logs" src="https://user-images.githubusercontent.com/66283081/119618019-b45ae580-be02-11eb-88b3-e296d33f37f8.png">

  

# V. Application Architecture:
<img width="1336" alt="Architecture" src="https://user-images.githubusercontent.com/66283081/119772388-5b9d5280-bebf-11eb-81f7-b4881fe54baa.png">


# VI. Flutter Packages I used:
• Camera
• Wakelock
• http
• async
• audioplayers
• vibration
  

# VII. Real Life Testing:
• Drivers have to buy a Mobile Phone holder to embed it in the Car Steering Wheel. It costs 31EGP ≅ $2. I already bought one from souq.com to test the Application. A <ins>**link**</ins> and a <ins>**picture**</ins> of the product are attached below.

https://egypt.souq.com/eg-en/functional-mobile-phone-holder-mount-clip-buckle-socket-hands-free-on-car-steering-wheel-7536478/i/

https://www.amazon.com/Mobile-Holder-Steering-Samsung-Cellphones/dp/B06XXQ6B3M/ref=sr_1_6?dchild=1&keywords=steering+wheel+mobile+holder&qid=1624660622&sr=8-6

<img width="346" alt="Mobile Phone Holder for Steering Wheel" src="https://user-images.githubusercontent.com/66283081/119617319-05b6a500-be02-11eb-890f-fb0ed5b1a26f.png">

# <ins>VIII. *Discussions:</ins>

• A better idea to implement this application is to try to embed a built-in camera in the steering wheel itself instead of the Mobile holder, this requires the acceptance of the car’s company. If the company accepted, a new feature may be added is to let the car itself flash if the driver slept, so that any nearby car knows that this car’s driver is sleeping.

• People may need to add their custom sounds to play, may consider it in the next version.

• It would be better to connect to the car’s audio, so when the sound starts to play, the volume will be high enough to wake the driver up.

• I may let the application works on background in the next versions.

• The camera is hidden and not previewed on the screen to avoid distracting the driver “Seeing himself”.

• I used the front camera instead of the rear one as the front one’s images’ size is smaller than the rear one, so the process of uploading the image to Rekognition API won’t take time to finish.

• The Free Tier for Amazon Rekognition allows 5000 images per month which is 166 images per day, 7 per hour, image per 8.5 minutes. Thus, results may not be accurate. So, a better way is to subscribe to this service, which costs $0.001 per image for the first 1 million images processed per month.

• May use ImageStreaming technique rather than capture an image every few seconds.


# IX. Known Issues:
• If the driver is wearing a glass, Rekognition will always detect his eyes as open even if they are closed.


# X. Screenshot of the Application:
<img width="400" alt="Screenshot of the Application" src="https://user-images.githubusercontent.com/66283081/119617836-7fe72980-be02-11eb-92fc-021097222494.PNG">


  <ins>**Advices to do:**</ins>
	
   • **Low Power Mode:** To reduce Battery Usage, as the Application may work for hours.
	  
   • **Do not disturb Mode:** To avoid distraction while driving. Ex: Notifications.
	  
   • **Internet:** To send a request to Rekognition API and receive the response (JSON).
	  
   • **Highest Volume:** To listen to the sound well when it plays (Better if connects with Cars’ Audio).
	  
   • **Lowest Brightness:** To reduce Battery Usage.


# XI. Application Logo:
<img width="150" alt="Application Logo" src="https://user-images.githubusercontent.com/66283081/119617250-eb7cc700-be01-11eb-9ef4-39fcffdb752b.png">


# XII. Application Size:
• 62 MB
  

# XIII. Battery Usage:
• 4% used at 1h 34m


# XIV. What I learned:
• Amazon Rekognition

• More Flutter


# XV. Built with:
• Amazon Rekognition

• Flutter

# Contact:
• mahmoud.ahmed48@msa.edu.eg

<br/>

#### Made with :heart: in Egypt
