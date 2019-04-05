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
	</strong>
</ol>