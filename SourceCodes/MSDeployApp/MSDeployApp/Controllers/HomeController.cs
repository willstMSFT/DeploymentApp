using System.Management.Automation;
using System.Web.Mvc;
using System.Collections.ObjectModel;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.IO;
using System.Data.SqlClient;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Management.Common;

namespace MSDeployApp.Controllers
{
    public class HomeController : Controller
    {

        public ActionResult Index()
        {
            return View();
        }

        //Azure SQl DB Function
        public ActionResult SqlDBFn(string azuid, string azpwd, string dbsrc, string dbuid, string dbpwd, string pbid, string pbpwd, string subsid)
        {
            using (PowerShell PowerShellInstance1 = PowerShell.Create())
            {
                //Login to Azure
                PowerShellInstance1.AddScript("$azureAccountName = '"+azuid+"';"
                    + "$azurePassword = ConvertTo-SecureString -String '"+azpwd+"' -AsPlainText -Force;"
                    + "$psCred = New-Object System.Management.Automation.PSCredential($azureAccountName,$azurePassword);");
                PowerShellInstance1.AddScript("Login-AzureRmAccount -Credential $psCred");
                Collection<PSObject> rs1 = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                var servername = dbsrc + $@"{System.DateTime.Now.Ticks}";
                string rgname = "ARM-DeployRG";
                var dbname = "bingNews";

                //Creating Resource Group
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("Select-AzureRmSubscription -SubscriptionID " + subsid);
                PowerShellInstance1.AddScript("New-AzureRmResourceGroup -Name $resourceGroupName -Location 'westus'");
                PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                //Deploying Dependent Resource's ARM Templates
                string TempPath1 = Server.MapPath(@"~\Service\AzureArm\DependARMTemplate.json");
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("Select-AzureRmSubscription -SubscriptionID " + subsid);
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " + TempPath1);
                Collection<PSObject> rst = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                //FunctionApp Template JSON Logic App Dynamic Values
                //Generating Unique File Name
                var myUniqueFileName0 = $@"{System.DateTime.Now.Ticks}.json";
                //Path of Temp File to be created
                string tempfile0 = Server.MapPath(@"~\App_Data\" + myUniqueFileName0);
                //Path of ARM Template
                string jsonFile00 = Server.MapPath(@"~\Service\AzureArm\Funtnapp.json");
                //Copying file
                System.IO.File.Copy(jsonFile00, tempfile0);
                //Changing the Params in TempFile0
                string json00 = System.IO.File.ReadAllText(tempfile0);
                var jObject00 = JObject.Parse(json00);
                //Generating unique resource names
                var fntnname = "fn" + $@"{System.DateTime.Now.Ticks}" + "nme";
                var appsername = "srv" + $@"{System.DateTime.Now.Ticks}" + "nme";
                var stracname = "str" + $@"{System.DateTime.Now.Ticks}" + "nme";
                jObject00["parameters"]["sites_test1123412_name"]["defaultValue"] = fntnname;
                jObject00["parameters"]["serverfarms_CentralUSPlan_name"]["defaultValue"] = appsername;
                jObject00["parameters"]["storageAccounts_test1123412ad54_name"]["defaultValue"] = stracname;
                string output00 = JsonConvert.SerializeObject(jObject00, Formatting.Indented);
                System.IO.File.WriteAllText(tempfile0, output00);


                //Deploying Azure Function App
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("Select-AzureRmSubscription -SubscriptionID " + subsid);
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " + tempfile0);
                Collection<PSObject> tfn = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                //Deleting the Temp File1
                System.IO.File.Delete(tempfile0);

                var testpath = Server.MapPath(@"~\App_Data\TestFile.txt");

                //Uploading Function App Zip Folder
                string zippath = Server.MapPath(@"~\Service\AzureArm\functionqfz47ane82.zip");
                PowerShellInstance1.AddScript("$resourceGroup = \"ARM-DeployRG\"");
                PowerShellInstance1.AddScript("$functionAppName = '"+fntnname+"'");
                PowerShellInstance1.AddScript("$creds = Invoke-AzureRmResourceAction -ResourceGroupName $resourceGroup -ResourceType Microsoft.Web/sites/config `             -ResourceName $functionAppName/publishingcredentials -Action list -ApiVersion 2015-08-01 -Force");
                PowerShellInstance1.AddScript("$username = $creds.Properties.PublishingUserName");
                PowerShellInstance1.AddScript("$password = $creds.Properties.PublishingPassword");
                PowerShellInstance1.AddScript("$filePath = '" + zippath + "'");
                PowerShellInstance1.AddScript("$apiUrl = \"https://"+fntnname+".azurewebsites.net/\"");
                PowerShellInstance1.AddScript("$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((\"{0}:{1}\" -f $username, $password)))");
                PowerShellInstance1.AddScript("$userAgent = \"powershell/1.0\"");
                PowerShellInstance1.AddScript("[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12");
                PowerShellInstance1.AddScript("Invoke-RestMethod -Uri $apiUrl -Headers @{Authorization=(\"Basic {0}\" -f $base64AuthInfo)} -UserAgent $userAgent -Method POST -InFile $filePath -ContentType \"multipart/form-data\" | Out-File -FilePath " + testpath);
                Collection<PSObject> gh = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();


                //ARM Template JSON Logic App Dynamic Values
                //Generating Unique File Name
                var myUniqueFileName1 = $@"{System.DateTime.Now.Ticks}.json";
                //Path of Temp File to be created
                string tempfile1 = Server.MapPath(@"~\App_Data\" + myUniqueFileName1);
                //Path of ARM Template
                string jsonFile1 = Server.MapPath(@"~\Service\AzureArm\ARMTemplate.json");
                //Copying file
                System.IO.File.Copy(jsonFile1, tempfile1);
                //Changing the Params in TempFile1
                string json1 = System.IO.File.ReadAllText(tempfile1);
                var jObject1 = JObject.Parse(json1);
                jObject1["parameters"]["sqlServer"]["defaultValue"] = servername;
                jObject1["parameters"]["sqlUser"]["defaultValue"] = dbuid;
                jObject1["parameters"]["sqlPassword"]["defaultValue"] = dbpwd;
                jObject1["parameters"]["sqlDatabase"]["defaultValue"] = dbname;
                jObject1["parameters"]["SubscriptionId"]["defaultValue"] = subsid;
                jObject1["parameters"]["sites_function06af1xdwag_name"]["defaultValue"] = fntnname;
                string output1 = JsonConvert.SerializeObject(jObject1, Formatting.Indented);
                System.IO.File.WriteAllText(tempfile1, output1);
                 
                //Deploying ARM Template
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("Select-AzureRmSubscription -SubscriptionID " + subsid);
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " +tempfile1);
                Collection<PSObject> rst7 = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                //Deleting the Temp File1
                System.IO.File.Delete(tempfile1);


                //ServerDB JSON Logic App Dynamic Values
                //Generating Unique File Name
                var myUniqueFileName2 = $@"{System.DateTime.Now.Ticks}.json";
                //Path of Temp File to be created
                string tempfile2 = Server.MapPath(@"~\App_Data\" + myUniqueFileName2);
                //Path of ServerDB Template
                string jsonFile0 = Server.MapPath(@"~\Service\AzureArm\ServerDB.json");
                //Copying file
                System.IO.File.Copy(jsonFile0, tempfile2);
                //Changing the Params in TempFile2
                string json0 = System.IO.File.ReadAllText(tempfile2);
                var jObject0 = JObject.Parse(json0);
                jObject0["parameters"]["serverName"]["defaultValue"] = servername;
                jObject0["parameters"]["serverAdminLogin"]["defaultValue"] = dbuid;
                jObject0["parameters"]["serverAdminLoginPassword"]["defaultValue"] = dbpwd;
                jObject0["parameters"]["databaseName"]["defaultValue"] = dbname;
                string output0 = JsonConvert.SerializeObject(jObject0, Formatting.Indented);
                System.IO.File.WriteAllText(tempfile2, output0);

                //Deploying ServerDB Template 
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("Select-AzureRmSubscription -SubscriptionID " + subsid);
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " +tempfile2);
                Collection<PSObject> tfn0 = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                //Deleting the Temp File2
                System.IO.File.Delete(tempfile2);


                //Executing SQL Script 1
                string sqlConnectionString1 = "Server=tcp:" + servername + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath1 = Server.MapPath(@"~\Service\Database\00_content_check.sql");//.sql file path
                FileInfo file1 = new FileInfo(sqlpath1);
                string script1 = file1.OpenText().ReadToEnd();
                SqlConnection conn1 = new SqlConnection(sqlConnectionString1);
                SqlCommand cmd1 = conn1.CreateCommand();
                cmd1.CommandTimeout = 3600;
                Server server1 = new Server(new ServerConnection(conn1));
                server1.ConnectionContext.ExecuteNonQuery(script1);

                //Executing SQL Script 2
                string sqlConnectionString2 = "Server=tcp:" + servername + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath2 = Server.MapPath(@"~\Service\Database\10_pre.sql");
                FileInfo file2 = new FileInfo(sqlpath2);
                string script2 = file2.OpenText().ReadToEnd();
                SqlConnection conn2 = new SqlConnection(sqlConnectionString2);
                SqlCommand cmd2 = conn2.CreateCommand();
                cmd2.CommandTimeout = 3600;
                Server server2 = new Server(new ServerConnection(conn2));
                server2.ConnectionContext.ExecuteNonQuery(script2);

                //Executing SQL Script 3
                string sqlConnectionString3 = "Server=tcp:" + servername + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath3 = Server.MapPath(@"~\Service\Database\20_tables.sql");
                FileInfo file3 = new FileInfo(sqlpath3);
                string script3 = file3.OpenText().ReadToEnd();
                SqlConnection conn3 = new SqlConnection(sqlConnectionString3);
                SqlCommand cmd3 = conn3.CreateCommand();
                cmd3.CommandTimeout = 3600;
                Server server3 = new Server(new ServerConnection(conn3));
                server3.ConnectionContext.ExecuteNonQuery(script3);

                //Executing SQL Script 4
                string sqlConnectionString4 = "Server=tcp:" + servername + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath4 = Server.MapPath(@"~\Service\Database\30_views.sql");
                FileInfo file4 = new FileInfo(sqlpath4);
                string script4 = file4.OpenText().ReadToEnd();
                SqlConnection conn4 = new SqlConnection(sqlConnectionString4);
                SqlCommand cmd4 = conn4.CreateCommand();
                cmd4.CommandTimeout = 3600;
                Server server4 = new Server(new ServerConnection(conn4));
                server4.ConnectionContext.ExecuteNonQuery(script4);

                //Executing SQL Script 5
                string sqlConnectionString5 = "Server=tcp:" + servername + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath5 = Server.MapPath(@"~\Service\Database\40_programmability.sql");
                FileInfo file5 = new FileInfo(sqlpath5);
                string script5 = file5.OpenText().ReadToEnd();
                SqlConnection conn5 = new SqlConnection(sqlConnectionString5);
                SqlCommand cmd5 = conn5.CreateCommand();
                cmd5.CommandTimeout = 3600;
                Server server5 = new Server(new ServerConnection(conn5));
                server5.ConnectionContext.ExecuteNonQuery(script5);

                //Executing SQL Script 6
                string sqlConnectionString6 = "Server=tcp:" + servername + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath6 = Server.MapPath(@"~\Service\Database\50_post.sql");
                FileInfo file6 = new FileInfo(sqlpath6);
                string script6 = file6.OpenText().ReadToEnd();
                SqlConnection conn6 = new SqlConnection(sqlConnectionString6);
                SqlCommand cmd6 = conn6.CreateCommand();
                cmd6.CommandTimeout = 3600;
                Server server6 = new Server(new ServerConnection(conn6));
                server6.ConnectionContext.ExecuteNonQuery(script6);

                //Executing SQL Script 7
                string sqlConnectionString7 = "Server=tcp:" + servername + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath7 = Server.MapPath(@"~\Service\Database\60_data.sql");
                FileInfo file7 = new FileInfo(sqlpath7);
                string script7 = file7.OpenText().ReadToEnd();
                SqlConnection conn7 = new SqlConnection(sqlConnectionString7);
                SqlCommand cmd7 = conn7.CreateCommand();
                cmd7.CommandTimeout = 3600;
                Server server7 = new Server(new ServerConnection(conn7));
                server7.ConnectionContext.ExecuteNonQuery(script7);

                //Executing SQL Script 8
                string sqlConnectionString8 = "Server=tcp:" + servername + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath8 = Server.MapPath(@"~\Service\Database\90_on-premise.sql");
                FileInfo file8 = new FileInfo(sqlpath8);
                string script8 = file8.OpenText().ReadToEnd();
                SqlConnection conn8 = new SqlConnection(sqlConnectionString8);
                SqlCommand cmd8 = conn8.CreateCommand();
                cmd8.CommandTimeout = 3600;
                Server server8 = new Server(new ServerConnection(conn8));
                server8.ConnectionContext.ExecuteNonQuery(script8);


                //Ml_Resource JSON Logic App Dynamic Values
                //Generating Unique File Name
                var myUniqueFileName3 = $@"{System.DateTime.Now.Ticks}.json";
                //Path of Temp File to be created
                string tempfile3 = Server.MapPath(@"~\App_Data\" + myUniqueFileName3);
                //Path of ML_Resource Template
                string jsonFile2 = Server.MapPath(@"~\Service\AzureArm\ML_Resource.json");
                //Copying file
                System.IO.File.Copy(jsonFile2, tempfile3);
                //Changing the Params in TempFile2
                string json2 = System.IO.File.ReadAllText(tempfile3);
                var jObject2 = JObject.Parse(json2);
                jObject2["parameters"]["sqlServer"]["defaultValue"] = servername;
                jObject2["parameters"]["sqlUser"]["defaultValue"] = dbuid;
                jObject2["parameters"]["sqlPassword"]["defaultValue"] = dbpwd;
                jObject2["parameters"]["sqlDatabase"]["defaultValue"] = dbname;
                jObject2["parameters"]["SubscriptionId"]["defaultValue"] = subsid;
                string output2 = JsonConvert.SerializeObject(jObject2, Formatting.Indented);
                System.IO.File.WriteAllText(tempfile3, output2);

                //Deploying ML_Resource LogicApp
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("Select-AzureRmSubscription -SubscriptionID " + subsid);
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " +tempfile3);
                Collection<PSObject> tfn1 = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                //Deleting the Temp File3
                System.IO.File.Delete(tempfile3);


                //LogicApps_ML JSON Logic App Dynamic Values
                //Generating Unique File Name
                var myUniqueFileName4 = $@"{System.DateTime.Now.Ticks}.json";
                //Path of Temp File to be created
                string tempfile4 = Server.MapPath(@"~\App_Data\" + myUniqueFileName4);
                //Path of LogicApps_ML Template
                string jsonFile4 = Server.MapPath(@"~\Service\AzureArm\LogicApps_ML.json");
                //Copying file
                System.IO.File.Copy(jsonFile4, tempfile4);
                //Changing the Params in TempFile4
                string json4 = System.IO.File.ReadAllText(tempfile4);
                var jObject4 = JObject.Parse(json4);
                jObject4["parameters"]["SubscriptionId"]["defaultValue"] = subsid;
                jObject4["parameters"]["sites_functionqfz47ane82_name"]["defaultValue"] = fntnname;
                string output4 = JsonConvert.SerializeObject(jObject4, Formatting.Indented);
                System.IO.File.WriteAllText(tempfile4, output4);


                //Deploying LogicApps_ML
                PowerShellInstance1.AddScript("$resourceGroupName = '"+rgname+"'");
                PowerShellInstance1.AddScript("Select-AzureRmSubscription -SubscriptionID " + subsid);
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " +tempfile4);
                Collection<PSObject> tfn2 = PowerShellInstance1.Invoke();
                 PowerShellInstance1.Commands.Clear();

                //Deleting the Temp File4
                System.IO.File.Delete(tempfile4);

            }

            return View("ARMFn");
        }


        //Deployment Summary Function
        public ActionResult ARMFn()
        {
            return View();
        }


    }
}