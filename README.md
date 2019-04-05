<h1>Keyword Sentiment Analysis</h1>

<a href="https://msdeployapp20190307110050.azurewebsites.net/" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://setupdataapp20190211120818.azurewebsites.net/" target="_blank">
    <img src="http://139.59.61.161/setupdata5.jpg"/ style="border-radius:5px;">
</a>
<br>
<h2>Instructions</h2>
<p>The following are the guidelines to get your Azure Subscription ID for input, to assign the cognitive services keys and to deploy the Power BI report.</p>
<h3>How to get Azure Subscription ID</h3>
<ol>
	<strong>
		<li>Login to your Azure account by navigating to https://portal.azure.com/</li>
		<li>In the Search box type “Subscriptions”, Click on “Subscriptions” from search result</li>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	       <img src="http://139.59.61.161/MicrosoftDeployment/1.%20Getting%20Subscription/01.PNG" alt="image" style="max-width:100%;">
        <li>Click on your Subscription ID</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/1.%20Getting%20Subscription/2.PNG" alt="image" style="max-width:100%;">
        <li>Grab your Subscription ID</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/1.%20Getting%20Subscription/3.PNG" alt="image" style="max-width:100%;">
  </strong>
</ol>
<h3>How to assign Cognitive Service Keys to API connections</h3>
<h4><strong>Bing Search:</strong></h4>
<ol>
	<strong>
		<li>Click on the “bingsearchtest” cognitive service in your deployed resource group</li>
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/01.PNG" alt="image" style="max-width:100%;">
		<li>Click on the “Keys” tab and copy any one of the key</li>
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/02.PNG" alt="image" style="max-width:100%;">
		<li>Click on the “bingsearch” API connection</li>
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/003.PNG" alt="image" style="max-width:100%;">
		<li>Click on the Edit API connection tab, paste the API key in the “API key” and click on save</li>
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/04.PNG" alt="image" style="max-width:100%;">
    </strong>
</ol>
<h4><strong>Text Analytics:</strong></h4>
<ol>
	<strong>
		<li>Click on the “textanalyticstest” cognitive service in your deployed resource group</li>
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/05.PNG" alt="image" style="max-width:100%;">
		<li>Click on the “Keys” tab and copy any one of the key</li>
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/06.PNG" alt="image" style="max-width:100%;">
		<li>Click on the “cognitiveservicestextanalytics” API connection</li>
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/07.PNG" alt="image" style="max-width:100%;">
		<li>Click on the Edit API connection tab, paste the API key in the “Account key” and click on save</li>
		   <img src="http://139.59.61.161/MicrosoftDeployment/2.%20Assigning%20Keys/08.PNG" alt="image" style="max-width:100%;">
	</strong>
</ol>
<h3>How to deploy Power BI Report</h3>
<ol>
	<strong>
		<li>Navigate to https://powerbi.microsoft.com/en-us/downloads/ to download Power BI Desktop</li>
		<li>Click on “Advanced download options”</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/1.PNG" alt="image" style="max-width:100%;">
        <li>Read the instructions and click on download</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/2.PNG" alt="image" style="max-width:100%;">
        <li>Select the required file according to your platform and click on next</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/3.PNG" alt="image" style="max-width:100%;">
        <li>Click on the downloaded file</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/4.PNG" alt="image" style="max-width:100%;">
        <li>Follow the instructions on the setup file, click on next</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/5.PNG" alt="image" style="max-width:100%;">
        <li>Accept the license and click on next</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/6.PNG" alt="image" style="max-width:100%;">  
        <li>Specify your installation path and click on next</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/7.PNG" alt="image" style="max-width:100%;">
        <li>Click on Install</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/8.PNG" alt="image" style="max-width:100%;">
        <li>Wait for the installation to complete</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/9.png" alt="image" style="max-width:100%;">
        <li>Once the installation is done, click on finish</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/10.png" alt="image" style="max-width:100%;">
        <li>Power BI Desktop will be get loaded, sign in using your Microsoft account</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/11.PNG" alt="image" style="max-width:100%;">
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/12.PNG" alt="image" style="max-width:100%;">
        <li>Open the “Sentiment Data Pipeline” report by clicking on File->Open and specify the path</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/13.png" alt="image" style="max-width:100%;">
        <li>Report will be opened, click on “Edit Queries” in the Menu bar</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/14.PNG" alt="image" style="max-width:100%;">
        <li>A new window called “Power Query Editor” will be opened, click on “Data Source settings”</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/15.PNG" alt="image" style="max-width:100%;">
        <li>Click on the “Change Source” button on the popup</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/16.PNG" alt="image" style="max-width:100%;">
        <li>Specify the server name that you were created and click on okay</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/17.PNG" alt="image" style="max-width:100%;">
        <li>Now click on “Edit Permissions”</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/18.PNG" alt="image" style="max-width:100%;">
        <li>Click on “Edit” in the popup</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/19.PNG" alt="image" style="max-width:100%;">
        <li>In the “Database” tab enter your DB credentials and click on save</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/20.PNG" alt="image" style="max-width:100%;">
        <li>Click on “OK” and Click on “Close”</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/21.PNG" alt="image" style="max-width:100%;">
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/22.PNG" alt="image" style="max-width:100%;">
        <li>Click on “STSqlServer” and change your server name</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/23.PNG" alt="image" style="max-width:100%;">
        <li>Close the Query editor and save the changes</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/24.PNG" alt="image" style="max-width:100%;">
        <li>Wait till the data gets loaded</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/25.PNG" alt="image" style="max-width:100%;">
        <li>Once the data loading is completed click on the “Publish” button in the menu bar</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/26.PNG" alt="image" style="max-width:100%;">
        <li>Click on save</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/27.PNG" alt="image" style="max-width:100%;">
        <li>Sign in with your Microsoft account to publish the report to Power BI Service</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/28.png" alt="image" style="max-width:100%;">
        <li>Enter your credentials and sign in</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/29.png" alt="image" style="max-width:100%;">
        <li>Select “My Workspace”</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/30.png" alt="image" style="max-width:100%;">
        <li>Wait till the report got published</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/31.png" alt="image" style="max-width:100%;">
         <li>Click on the “Open” link to view the report in Power BI Service</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/32.png" alt="image" style="max-width:100%;">
         <li>Sign in with your same Microsoft Account to login the Power BI Service</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/33.PNG" alt="image" style="max-width:100%;">
        <li>Click on “Reports”</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/34.PNG" alt="image" style="max-width:100%;">
        <li>Published report will be displayed</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/35.PNG" alt="image" style="max-width:100%;">
        <li>To update the report with new data, click on “Refresh” button in Power BI Desktop</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/36.PNG" alt="image" style="max-width:100%;">
        <li>Wait till all the data get refreshed</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/37.PNG" alt="image" style="max-width:100%;">
        <li>After every refresh republish the report to Power BI Service</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/38.PNG" alt="image" style="max-width:100%;">
        <li>Report will be republished once you click on replace</li>
           <img src="http://139.59.61.161/MicrosoftDeployment/3.%20PBI/39.PNG" alt="image" style="max-width:100%;">
	</strong>
</ol>