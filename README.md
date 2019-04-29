<h1>Keyword Sentiment Analysis</h1>

<a href="https://msdeployapp20190307110050.azurewebsites.net/" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://setupdataapp20190211120818.azurewebsites.net/" target="_blank">
    <img src="http://139.59.61.161/MicrosoftDeployment/setupdata5.jpg"/ style="border-radius:5px;">
</a>
<br>
<h2>Instructions</h2>
<p>The following are the guidelines to get your Azure Subscription ID for input, to assign the cognitive services keys and to deploy the Power BI report.</p>
<h3>How to get Azure Subscription ID</h3>
<ol>
	<strong>
		<li>Login to your Azure account by navigating to https://portal.azure.com/</li>
		<li>In the Search box type “Subscriptions”, Click on “Subscriptions” from search result</li>
		 &nbsp;&nbsp;&nbsp;
	       <img src="http://139.59.61.161/MicrosoftDeployment/1.%20Getting%20Subscription/01.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Click on your Subscription ID</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/1.%20Getting%20Subscription/2.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Grab your Subscription ID</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/1.%20Getting%20Subscription/3.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
  </strong>
</ol>
<h3>How to assign Cognitive Service Keys to API connections</h3>
<h4><strong>Bing Search:</strong></h4>
<ol>
	<strong>
		<li>Click on the “bingsearchtest” cognitive service in your deployed resource group</li>
		 &nbsp;&nbsp;&nbsp;
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/01.PNG" alt="image" style="max-width:100%;">
		 &nbsp;&nbsp;&nbsp;
		<li>Click on the “Keys” tab and copy any one of the key</li>
		 &nbsp;&nbsp;&nbsp;
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/02.PNG" alt="image" style="max-width:100%;">
		 &nbsp;&nbsp;&nbsp;
		<li>Click on the “bingsearch” API connection</li>
		 &nbsp;&nbsp;&nbsp;
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/003.PNG" alt="image" style="max-width:100%;">
		 &nbsp;&nbsp;&nbsp;
		<li>Click on the Edit API connection tab, paste the API key in the “API key” and click on save</li>
		 &nbsp;&nbsp;&nbsp;
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/04.PNG" alt="image" style="max-width:100%;">
		 &nbsp;&nbsp;&nbsp;
    </strong>
</ol>
<h4><strong>Text Analytics:</strong></h4>
<ol>
	<strong>
		<li>Click on the “textanalyticstest” cognitive service in your deployed resource group</li>
		 &nbsp;&nbsp;&nbsp;
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/05.PNG" alt="image" style="max-width:100%;">
		 &nbsp;&nbsp;&nbsp;
		<li>Click on the “Keys” tab and copy any one of the key</li>
		 &nbsp;&nbsp;&nbsp;
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/06.PNG" alt="image" style="max-width:100%;">
		 &nbsp;&nbsp;&nbsp;
		<li>Click on the “cognitiveservicestextanalytics” API connection</li>
		 &nbsp;&nbsp;&nbsp;
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/07.PNG" alt="image" style="max-width:100%;">
		 &nbsp;&nbsp;&nbsp;
		<li>Click on the Edit API connection tab, paste the API key in the “Account key” and click on save</li>
		 &nbsp;&nbsp;&nbsp;
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/08.PNG" alt="image" style="max-width:100%;">
		 &nbsp;&nbsp;&nbsp;
	</strong>
</ol>
<h3>Reconnection to be made in Logic App</h3>
<ol>
  <strong>
    <li>Click on your LogicApp 'mainflowappnewclone_ARM'</li>
     &nbsp;&nbsp;&nbsp;
       <img src="http://139.59.61.161/MicrosoftDeployment/4.%20Logic%20App/000.PNG" alt="image" style="max-width:100%;">
     &nbsp;&nbsp;&nbsp;
    <li>Click on Edit</li>
     &nbsp;&nbsp;&nbsp;
       <img src="http://139.59.61.161/MicrosoftDeployment/4.%20Logic%20App/00.PNG" alt="image" style="max-width:100%;">
     &nbsp;&nbsp;&nbsp;
     <li>Click on Step 2 'Get row'</li>
     &nbsp;&nbsp;&nbsp;
       <img src="http://139.59.61.161/MicrosoftDeployment/4.%20Logic%20App/0.PNG" alt="image" style="max-width:100%;">
     &nbsp;&nbsp;&nbsp;
     <li>Click on 'Change connection'</li>
     &nbsp;&nbsp;&nbsp;
       <img src="http://139.59.61.161/MicrosoftDeployment/4.%20Logic%20App/1.PNG" alt="image" style="max-width:100%;">
     &nbsp;&nbsp;&nbsp;
     <li>Click on 'Add new connection'</li>
     &nbsp;&nbsp;&nbsp;
       <img src="http://139.59.61.161/MicrosoftDeployment/4.%20Logic%20App/2.PNG" alt="image" style="max-width:100%;">
     &nbsp;&nbsp;&nbsp;
     <li>Select your deployed server</li>
     &nbsp;&nbsp;&nbsp;
       <img src="http://139.59.61.161/MicrosoftDeployment/4.%20Logic%20App/3.PNG" alt="image" style="max-width:100%;">
     &nbsp;&nbsp;&nbsp;
    <li>Select your deployed database</li>
     &nbsp;&nbsp;&nbsp;
       <img src="http://139.59.61.161/MicrosoftDeployment/4.%20Logic%20App/4.PNG" alt="image" style="max-width:100%;">
     &nbsp;&nbsp;&nbsp;
    <li>Fill with the credentials</li>
     &nbsp;&nbsp;&nbsp;
       <img src="http://139.59.61.161/MicrosoftDeployment/4.%20Logic%20App/5.PNG" alt="image" style="max-width:100%;">
     &nbsp;&nbsp;&nbsp;
  </strong>
</ol>
<h3>How to deploy Power BI Report</h3>
<ol>
	<strong>
		<li>Navigate to https://powerbi.microsoft.com/en-us/downloads/ to download Power BI Desktop</li>
		 &nbsp;&nbsp;&nbsp;
		<li>Click on “Advanced download options”</li>
		 &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/1.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Read the instructions and click on download</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/2.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Select the required file according to your platform and click on next</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/3.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Click on the downloaded file</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/4.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Follow the instructions on the setup file, click on next</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/5.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Accept the license and click on next</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/6.PNG" alt="image" style="max-width:100%;"> 
         &nbsp;&nbsp;&nbsp; 
        <li>Specify your installation path and click on next</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/7.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Click on Install</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/8.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Wait for the installation to complete</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/9.png" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Once the installation is done, click on finish</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/10.png" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Power BI Desktop will be get loaded, sign in using your Microsoft account</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/11.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/12.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Open the “Sentiment Data Pipeline” report by clicking on File->Open and specify the path</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/13.png" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Report will be opened, click on “Edit Queries” in the Menu bar</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/14.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>A new window called “Power Query Editor” will be opened, click on “Data Source settings”</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/15.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Click on the “Change Source” button on the popup</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/16.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Specify the server name that you were created and click on okay</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/17.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Now click on “Edit Permissions”</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/18.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Click on “Edit” in the popup</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/19.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>In the “Database” tab enter your DB credentials and click on save</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/20.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Click on “OK” and Click on “Close”</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/21.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/22.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Click on “STSqlServer” and change your server name</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/23.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Close the Query editor and save the changes</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/24.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Wait till the data gets loaded</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/25.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Once the data loading is completed click on the “Publish” button in the menu bar</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/26.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Click on save</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/27.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Sign in with your Microsoft account to publish the report to Power BI Service</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/28.png" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Enter your credentials and sign in</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/29.png" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Select “My Workspace”</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/30.png" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Wait till the report got published</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/31.png" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Click on the “Open” link to view the report in Power BI Service</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/32.png" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Sign in with your same Microsoft Account to login the Power BI Service</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/33.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Click on “Reports”</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/34.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Published report will be displayed</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/35.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>To update the report with new data, click on “Refresh” button in Power BI Desktop</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/36.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Wait till all the data get refreshed</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/37.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>After every refresh republish the report to Power BI Service</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/38.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
        <li>Report will be republished once you click on replace</li>
         &nbsp;&nbsp;&nbsp;
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/39.PNG" alt="image" style="max-width:100%;">
         &nbsp;&nbsp;&nbsp;
	</strong>
</ol>
<h3>To get Power BI Web URL</h3>
<ol>
  <strong>
       <li>On your Power BI Service, Click on File -> Publish To Web</li>
        &nbsp;&nbsp;&nbsp;
          <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/40.PNG" alt="image" style="max-width:100%;">
        &nbsp;&nbsp;&nbsp;
      <li>Copy your Power BI Web URL</li>
       &nbsp;&nbsp;&nbsp;
          <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/41.PNG" alt="image" style="max-width:100%;">
       &nbsp;&nbsp;&nbsp;
  </strong>
</ol>