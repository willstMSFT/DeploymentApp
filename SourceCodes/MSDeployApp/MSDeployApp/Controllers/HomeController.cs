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
        public ActionResult SqlDBFn(string azuid, string azpwd, string dbsrc, string dbuid, string dbpwd, string pbid, string pbpwd)
        {
            using (PowerShell PowerShellInstance1 = PowerShell.Create())
            {
                //Login to Azure
                PowerShellInstance1.AddScript("$azureAccountName = '" + azuid + "';"
                    + "$azurePassword = ConvertTo-SecureString -String '" + azpwd + "' -AsPlainText -Force;"
                    + "$psCred = New-Object System.Management.Automation.PSCredential($azureAccountName,$azurePassword);");
                PowerShellInstance1.AddScript("Login-AzureRmAccount -Credential $psCred");
                PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                string rgname = "ARM-DeployRG";
                var dbname = "bingNews";

                //Creating Resource Group
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("New-AzureRmResourceGroup -Name $resourceGroupName -Location 'westus'");
                PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                //Deploying Dependent Resource's ARM Template
                string TempPath1 = Server.MapPath(@"~\App_Data\DependARMTemplate.json");
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " + TempPath1);
                Collection<PSObject> rst = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                
                //ARM Template JSON Logic App Dynamic Values
                //Generating Unique File Name
                var myUniqueFileName1 = $@"{System.DateTime.Now.Ticks}.json";
                //Path of Temp File to be created
                string tempfile1 = Server.MapPath(@"~\App_Data\" + myUniqueFileName1);
                //Path of ARM Template
                string jsonFile1 = Server.MapPath(@"~\App_Data\ARMTemplate.json");
                //Copying file
                System.IO.File.Copy(jsonFile1, tempfile1);
                //Changing the Params in TempFile1
                string json1 = System.IO.File.ReadAllText(tempfile1);
                var jObject1 = JObject.Parse(json1);
                jObject1["parameters"]["sqlServer"]["defaultValue"] = dbsrc;
                jObject1["parameters"]["sqlUser"]["defaultValue"] = dbuid;
                jObject1["parameters"]["sqlPassword"]["defaultValue"] = dbpwd;
                jObject1["parameters"]["sqlDatabase"]["defaultValue"] = dbname;
                string output1 = JsonConvert.SerializeObject(jObject1, Formatting.Indented);
                System.IO.File.WriteAllText(tempfile1, output1);
                
                //Deploying ARM Template
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
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
                string jsonFile0 = Server.MapPath(@"~\App_Data\ServerDB.json");
                //Copying file
                System.IO.File.Copy(jsonFile0, tempfile2);
                //Changing the Params in TempFile2
                string json0 = System.IO.File.ReadAllText(tempfile2);
                var jObject0 = JObject.Parse(json0);
                jObject0["parameters"]["serverName"]["defaultValue"] = dbsrc;
                jObject0["parameters"]["serverAdminLogin"]["defaultValue"] = dbuid;
                jObject0["parameters"]["serverAdminLoginPassword"]["defaultValue"] = dbpwd;
                jObject0["parameters"]["databaseName"]["defaultValue"] = dbname;
                string output0 = JsonConvert.SerializeObject(jObject0, Formatting.Indented);
                System.IO.File.WriteAllText(tempfile2, output0);

                //Deploying ServerDB Template 
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " +tempfile2);
                Collection<PSObject> tfn0 = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                //Deleting the Temp File2
                System.IO.File.Delete(tempfile2);


                //Executing SQL Script 1
                string sqlConnectionString1 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath1 = Server.MapPath(@"~\App_Data\Amnesty_BingNews1.sql");//.sql file path
                FileInfo file1 = new FileInfo(sqlpath1);
                string script1 = file1.OpenText().ReadToEnd();
                SqlConnection conn1 = new SqlConnection(sqlConnectionString1);
                SqlCommand cmd1 = conn1.CreateCommand();
                cmd1.CommandTimeout = 3600;
                Server server1 = new Server(new ServerConnection(conn1));
                server1.ConnectionContext.ExecuteNonQuery(script1);

                //Executing SQL Script 2
                string sqlConnectionString2 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath2 = Server.MapPath(@"~\App_Data\Amnesty_BingNews2.sql");
                FileInfo file2 = new FileInfo(sqlpath2);
                string script2 = file2.OpenText().ReadToEnd();
                SqlConnection conn2 = new SqlConnection(sqlConnectionString2);
                SqlCommand cmd2 = conn2.CreateCommand();
                cmd2.CommandTimeout = 3600;
                Server server2 = new Server(new ServerConnection(conn2));
                server2.ConnectionContext.ExecuteNonQuery(script2);

                //Executing SQL Script 3
                string sqlConnectionString3 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath3 = Server.MapPath(@"~\App_Data\Amnesty_BingNews3.sql");
                FileInfo file3 = new FileInfo(sqlpath3);
                string script3 = file3.OpenText().ReadToEnd();
                SqlConnection conn3 = new SqlConnection(sqlConnectionString3);
                SqlCommand cmd3 = conn3.CreateCommand();
                cmd3.CommandTimeout = 3600;
                Server server3 = new Server(new ServerConnection(conn3));
                server3.ConnectionContext.ExecuteNonQuery(script3);

                //Executing SQL Script 4
                string sqlConnectionString4 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath4 = Server.MapPath(@"~\App_Data\Amnesty_BingNews4.sql");
                FileInfo file4 = new FileInfo(sqlpath4);
                string script4 = file4.OpenText().ReadToEnd();
                SqlConnection conn4 = new SqlConnection(sqlConnectionString4);
                SqlCommand cmd4 = conn4.CreateCommand();
                cmd4.CommandTimeout = 3600;
                Server server4 = new Server(new ServerConnection(conn4));
                server4.ConnectionContext.ExecuteNonQuery(script4);

                //Executing SQL Script 5
                string sqlConnectionString5 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath5 = Server.MapPath(@"~\App_Data\Amnesty_BingNews5.sql");
                FileInfo file5 = new FileInfo(sqlpath5);
                string script5 = file5.OpenText().ReadToEnd();
                SqlConnection conn5 = new SqlConnection(sqlConnectionString5);
                SqlCommand cmd5 = conn5.CreateCommand();
                cmd5.CommandTimeout = 3600;
                Server server5 = new Server(new ServerConnection(conn5));
                server5.ConnectionContext.ExecuteNonQuery(script5);

                //Executing SQL Script 6
                string sqlConnectionString6 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath6 = Server.MapPath(@"~\App_Data\Amnesty_BingNews6.sql");
                FileInfo file6 = new FileInfo(sqlpath6);
                string script6 = file6.OpenText().ReadToEnd();
                SqlConnection conn6 = new SqlConnection(sqlConnectionString6);
                SqlCommand cmd6 = conn6.CreateCommand();
                cmd6.CommandTimeout = 3600;
                Server server6 = new Server(new ServerConnection(conn6));
                server6.ConnectionContext.ExecuteNonQuery(script6);

                //Executing SQL Script 7
                string sqlConnectionString7 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath7 = Server.MapPath(@"~\App_Data\Amnesty_BingNews7.sql");
                FileInfo file7 = new FileInfo(sqlpath7);
                string script7 = file7.OpenText().ReadToEnd();
                SqlConnection conn7 = new SqlConnection(sqlConnectionString7);
                SqlCommand cmd7 = conn7.CreateCommand();
                cmd7.CommandTimeout = 3600;
                Server server7 = new Server(new ServerConnection(conn7));
                server7.ConnectionContext.ExecuteNonQuery(script7);

                //Executing SQL Script 8
                string sqlConnectionString8 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath8 = Server.MapPath(@"~\App_Data\Amnesty_BingNews8.sql");
                FileInfo file8 = new FileInfo(sqlpath8);
                string script8 = file8.OpenText().ReadToEnd();
                SqlConnection conn8 = new SqlConnection(sqlConnectionString8);
                SqlCommand cmd8 = conn8.CreateCommand();
                cmd8.CommandTimeout = 3600;
                Server server8 = new Server(new ServerConnection(conn8));
                server8.ConnectionContext.ExecuteNonQuery(script8);

                //Executing SQL Script 8-1
                string sqlConnectionString81 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath81 = Server.MapPath(@"~\App_Data\Amnesty_BingNews8-1.sql");
                FileInfo file81 = new FileInfo(sqlpath81);
                string script81 = file81.OpenText().ReadToEnd();
                SqlConnection conn81 = new SqlConnection(sqlConnectionString81);
                SqlCommand cmd81 = conn81.CreateCommand();
                cmd81.CommandTimeout = 3600;
                Server server81 = new Server(new ServerConnection(conn81));
                server81.ConnectionContext.ExecuteNonQuery(script81);

                //Executing SQL Script 9
                string sqlConnectionString9 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath9 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9.sql");
                FileInfo file9 = new FileInfo(sqlpath9);
                string script9 = file9.OpenText().ReadToEnd();
                SqlConnection conn9 = new SqlConnection(sqlConnectionString9);
                SqlCommand cmd9 = conn9.CreateCommand();
                cmd9.CommandTimeout = 3600;
                Server server9 = new Server(new ServerConnection(conn9));
                server9.ConnectionContext.ExecuteNonQuery(script9);

                //Executing SQL Script 9-1
                string sqlConnectionString91 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath91 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-1.sql");
                FileInfo file91 = new FileInfo(sqlpath91);
                string script91 = file91.OpenText().ReadToEnd();
                SqlConnection conn91 = new SqlConnection(sqlConnectionString91);
                SqlCommand cmd91 = conn91.CreateCommand();
                cmd91.CommandTimeout = 3600;
                Server server91 = new Server(new ServerConnection(conn91));
                server91.ConnectionContext.ExecuteNonQuery(script91);

                //Executing SQL Script 9-2
                string sqlConnectionString92 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath92 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-2.sql");
                FileInfo file92 = new FileInfo(sqlpath92);
                string script92 = file92.OpenText().ReadToEnd();
                SqlConnection conn92 = new SqlConnection(sqlConnectionString92);
                SqlCommand cmd92 = conn92.CreateCommand();
                cmd92.CommandTimeout = 3600;
                Server server92 = new Server(new ServerConnection(conn92));
                server92.ConnectionContext.ExecuteNonQuery(script92);

                //Executing SQL Script 9-3
                string sqlConnectionString93 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath93 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-3.sql");
                FileInfo file93 = new FileInfo(sqlpath93);
                string script93 = file93.OpenText().ReadToEnd();
                SqlConnection conn93 = new SqlConnection(sqlConnectionString93);
                SqlCommand cmd93 = conn93.CreateCommand();
                cmd93.CommandTimeout = 3600;
                Server server93 = new Server(new ServerConnection(conn93));
                server93.ConnectionContext.ExecuteNonQuery(script93);

                //Executing SQL Script 9-4
                string sqlConnectionString94 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath94 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-4.sql");
                FileInfo file94 = new FileInfo(sqlpath94);
                string script94 = file94.OpenText().ReadToEnd();
                SqlConnection conn94 = new SqlConnection(sqlConnectionString94);
                SqlCommand cmd94 = conn94.CreateCommand();
                cmd94.CommandTimeout = 3600;
                Server server94 = new Server(new ServerConnection(conn94));
                server94.ConnectionContext.ExecuteNonQuery(script94);

                //Executing SQL Script 9-5
                string sqlConnectionString95 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath95 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-5.sql");
                FileInfo file95 = new FileInfo(sqlpath95);
                string script95 = file95.OpenText().ReadToEnd();
                SqlConnection conn95 = new SqlConnection(sqlConnectionString95);
                SqlCommand cmd95 = conn95.CreateCommand();
                cmd95.CommandTimeout = 3600;
                Server server95 = new Server(new ServerConnection(conn95));
                server95.ConnectionContext.ExecuteNonQuery(script95);

                //Executing SQL Script 9-6
                string sqlConnectionString96 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath96 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-6.sql");
                FileInfo file96 = new FileInfo(sqlpath96);
                string script96 = file96.OpenText().ReadToEnd();
                SqlConnection conn96 = new SqlConnection(sqlConnectionString96);
                SqlCommand cmd96 = conn96.CreateCommand();
                cmd96.CommandTimeout = 3600;
                Server server96 = new Server(new ServerConnection(conn96));
                server96.ConnectionContext.ExecuteNonQuery(script96);

                //Executing SQL Script 9-7
                string sqlConnectionString97 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath97 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-7.sql");
                FileInfo file97 = new FileInfo(sqlpath97);
                string script97 = file97.OpenText().ReadToEnd();
                SqlConnection conn97 = new SqlConnection(sqlConnectionString97);
                SqlCommand cmd97 = conn97.CreateCommand();
                cmd97.CommandTimeout = 3600;
                Server server97 = new Server(new ServerConnection(conn97));
                server97.ConnectionContext.ExecuteNonQuery(script97);

                //Executing SQL Script 9-8
                string sqlConnectionString98 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath98 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-8.sql");
                FileInfo file98 = new FileInfo(sqlpath98);
                string script98 = file98.OpenText().ReadToEnd();
                SqlConnection conn98 = new SqlConnection(sqlConnectionString98);
                SqlCommand cmd98 = conn98.CreateCommand();
                cmd98.CommandTimeout = 3600;
                Server server98 = new Server(new ServerConnection(conn98));
                server98.ConnectionContext.ExecuteNonQuery(script98);

                //Executing SQL Script 9-9
                string sqlConnectionString99 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath99 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-9.sql");
                FileInfo file99 = new FileInfo(sqlpath99);
                string script99 = file99.OpenText().ReadToEnd();
                SqlConnection conn99 = new SqlConnection(sqlConnectionString99);
                SqlCommand cmd99 = conn99.CreateCommand();
                cmd99.CommandTimeout = 3600;
                Server server99 = new Server(new ServerConnection(conn99));
                server99.ConnectionContext.ExecuteNonQuery(script99);

                //Executing SQL Script 9-10
                string sqlConnectionString910 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath910 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-10.sql");
                FileInfo file910 = new FileInfo(sqlpath910);
                string script910 = file910.OpenText().ReadToEnd();
                SqlConnection conn910 = new SqlConnection(sqlConnectionString910);
                SqlCommand cmd910 = conn910.CreateCommand();
                cmd910.CommandTimeout = 3600;
                Server server910 = new Server(new ServerConnection(conn910));
                server910.ConnectionContext.ExecuteNonQuery(script910);

                //Executing SQL Script 9-11
                string sqlConnectionString911 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath911 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-11.sql");
                FileInfo file911 = new FileInfo(sqlpath911);
                string script911 = file911.OpenText().ReadToEnd();
                SqlConnection conn911 = new SqlConnection(sqlConnectionString911);
                SqlCommand cmd911 = conn911.CreateCommand();
                cmd911.CommandTimeout = 3600;
                Server server911 = new Server(new ServerConnection(conn911));
                server911.ConnectionContext.ExecuteNonQuery(script911);

                //Executing SQL Script 9-12
                string sqlConnectionString912 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath912 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-12.sql");
                FileInfo file912 = new FileInfo(sqlpath912);
                string script912 = file912.OpenText().ReadToEnd();
                SqlConnection conn912 = new SqlConnection(sqlConnectionString912);
                SqlCommand cmd912 = conn912.CreateCommand();
                cmd912.CommandTimeout = 3600;
                Server server912 = new Server(new ServerConnection(conn912));
                server912.ConnectionContext.ExecuteNonQuery(script912);

                //Executing SQL Script 9-13
                string sqlConnectionString913 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath913 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-13.sql");
                FileInfo file913 = new FileInfo(sqlpath913);
                string script913 = file913.OpenText().ReadToEnd();
                SqlConnection conn913 = new SqlConnection(sqlConnectionString913);
                SqlCommand cmd913 = conn913.CreateCommand();
                cmd913.CommandTimeout = 3600;
                Server server913 = new Server(new ServerConnection(conn913));
                server913.ConnectionContext.ExecuteNonQuery(script913);

                //Executing SQL Script 9-14
                string sqlConnectionString914 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath914 = Server.MapPath(@"~\App_Data\Amnesty_BingNews9-14.sql");
                FileInfo file914 = new FileInfo(sqlpath914);
                string script914 = file914.OpenText().ReadToEnd();
                SqlConnection conn914 = new SqlConnection(sqlConnectionString914);
                SqlCommand cmd914 = conn914.CreateCommand();
                cmd914.CommandTimeout = 3600;
                Server server914 = new Server(new ServerConnection(conn914));
                server914.ConnectionContext.ExecuteNonQuery(script914);

                //Executing SQL Script 10
                string sqlConnectionString10 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath10 = Server.MapPath(@"~\App_Data\Amnesty_BingNews10.sql");
                FileInfo file10 = new FileInfo(sqlpath10);
                string script10 = file10.OpenText().ReadToEnd();
                SqlConnection conn10 = new SqlConnection(sqlConnectionString10);
                SqlCommand cmd10 = conn10.CreateCommand();
                cmd10.CommandTimeout = 3600;
                Server server10 = new Server(new ServerConnection(conn10));
                server10.ConnectionContext.ExecuteNonQuery(script10);

                //Executing SQL Script 10.0
                string sqlConnectionString100 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath100 = Server.MapPath(@"~\App_Data\Amnesty_BingNews10-0.sql");
                FileInfo file100 = new FileInfo(sqlpath100);
                string script100 = file100.OpenText().ReadToEnd();
                SqlConnection conn100 = new SqlConnection(sqlConnectionString100);
                SqlCommand cmd100 = conn100.CreateCommand();
                cmd100.CommandTimeout = 3600;
                Server server100 = new Server(new ServerConnection(conn100));
                server100.ConnectionContext.ExecuteNonQuery(script100);


                //Executing SQL Script 10-2
                string sqlConnectionString102 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath102 = Server.MapPath(@"~\App_Data\Amnesty_BingNews10-2.sql");
                FileInfo file102 = new FileInfo(sqlpath102);
                string script102 = file102.OpenText().ReadToEnd();
                SqlConnection conn102 = new SqlConnection(sqlConnectionString102);
                SqlCommand cmd102 = conn102.CreateCommand();
                cmd102.CommandTimeout = 3600;
                Server server102 = new Server(new ServerConnection(conn102));
                server102.ConnectionContext.ExecuteNonQuery(script102);

                //Executing SQL Script 10-3
                string sqlConnectionString103 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath103 = Server.MapPath(@"~\App_Data\Amnesty_BingNews10-3.sql");
                FileInfo file103 = new FileInfo(sqlpath103);
                string script103 = file103.OpenText().ReadToEnd();
                SqlConnection conn103 = new SqlConnection(sqlConnectionString103);
                SqlCommand cmd103 = conn103.CreateCommand();
                cmd103.CommandTimeout = 3600;
                Server server103 = new Server(new ServerConnection(conn103));
                server103.ConnectionContext.ExecuteNonQuery(script103);

                //Executing SQL Script 10-4
                string sqlConnectionString104 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath104 = Server.MapPath(@"~\App_Data\Amnesty_BingNews10-4.sql");
                FileInfo file104 = new FileInfo(sqlpath104);
                string script104 = file104.OpenText().ReadToEnd();
                SqlConnection conn104 = new SqlConnection(sqlConnectionString104);
                SqlCommand cmd104 = conn104.CreateCommand();
                cmd104.CommandTimeout = 3600;
                Server server104 = new Server(new ServerConnection(conn104));
                server104.ConnectionContext.ExecuteNonQuery(script104);

                //Executing SQL Script 10-5
                string sqlConnectionString105 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath105 = Server.MapPath(@"~\App_Data\Amnesty_BingNews10-5.sql");
                FileInfo file105 = new FileInfo(sqlpath105);
                string script105 = file105.OpenText().ReadToEnd();
                SqlConnection conn105 = new SqlConnection(sqlConnectionString105);
                SqlCommand cmd105 = conn105.CreateCommand();
                cmd105.CommandTimeout = 3600;
                Server server105 = new Server(new ServerConnection(conn105));
                server105.ConnectionContext.ExecuteNonQuery(script105);

                //Executing SQL Script 10-6
                string sqlConnectionString106 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath106 = Server.MapPath(@"~\App_Data\Amnesty_BingNews10-6.sql");
                FileInfo file106 = new FileInfo(sqlpath106);
                string script106 = file106.OpenText().ReadToEnd();
                SqlConnection conn106 = new SqlConnection(sqlConnectionString106);
                SqlCommand cmd106 = conn106.CreateCommand();
                cmd106.CommandTimeout = 3600;
                Server server106 = new Server(new ServerConnection(conn106));
                server106.ConnectionContext.ExecuteNonQuery(script106);

                //Executing SQL Script 10-7
                string sqlConnectionString107 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath107 = Server.MapPath(@"~\App_Data\Amnesty_BingNews10-7.sql");
                FileInfo file107 = new FileInfo(sqlpath107);
                string script107 = file107.OpenText().ReadToEnd();
                SqlConnection conn107 = new SqlConnection(sqlConnectionString107);
                SqlCommand cmd107 = conn107.CreateCommand();
                cmd107.CommandTimeout = 3600;
                Server server107 = new Server(new ServerConnection(conn107));
                server107.ConnectionContext.ExecuteNonQuery(script107);

                //Executing SQL Script 11
                string sqlConnectionString11 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath11 = Server.MapPath(@"~\App_Data\Amnesty_BingNews11.sql");
                FileInfo file11 = new FileInfo(sqlpath11);
                string script11 = file11.OpenText().ReadToEnd();
                SqlConnection conn11 = new SqlConnection(sqlConnectionString11);
                SqlCommand cmd11 = conn11.CreateCommand();
                cmd11.CommandTimeout = 3600;
                Server server11 = new Server(new ServerConnection(conn11));
                server11.ConnectionContext.ExecuteNonQuery(script11);

                //Executing SQL Script 11-0
                string sqlConnectionString110 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath110 = Server.MapPath(@"~\App_Data\Amnesty_BingNews11-0.sql");
                FileInfo file110 = new FileInfo(sqlpath110);
                string script110 = file110.OpenText().ReadToEnd();
                SqlConnection conn110 = new SqlConnection(sqlConnectionString110);
                SqlCommand cmd110 = conn110.CreateCommand();
                cmd110.CommandTimeout = 3600;
                Server server110 = new Server(new ServerConnection(conn110));
                server110.ConnectionContext.ExecuteNonQuery(script110);

                //Executing SQL Script 11-1
                string sqlConnectionString111 = "Server=tcp:" + dbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + dbuid + ";Password=" + dbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";
                string sqlpath111 = Server.MapPath(@"~\App_Data\Amnesty_BingNews11-1.sql");
                FileInfo file111 = new FileInfo(sqlpath111);
                string script111 = file111.OpenText().ReadToEnd();
                SqlConnection conn111 = new SqlConnection(sqlConnectionString111);
                SqlCommand cmd111 = conn111.CreateCommand();
                cmd111.CommandTimeout = 3600;
                Server server111 = new Server(new ServerConnection(conn111));
                server111.ConnectionContext.ExecuteNonQuery(script111);


                //Deploying Azure Function App
                string TempPath3 = Server.MapPath(@"~\App_Data\Funtnapp.json");
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " + TempPath3);
                Collection<PSObject> tfn = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                var testpath = Server.MapPath(@"~\App_Data\TestFile.txt");

                //Uploading Function App Zip Folder
                string zippath = Server.MapPath(@"~\App_Data\functionqfz47ane82.zip");
                PowerShellInstance1.AddScript("$resourceGroup = \"ARM-DeployRG\"");
                PowerShellInstance1.AddScript("$functionAppName = \"test1123412te12121\"");
                PowerShellInstance1.AddScript("$creds = Invoke-AzureRmResourceAction -ResourceGroupName $resourceGroup -ResourceType Microsoft.Web/sites/config `             -ResourceName $functionAppName/publishingcredentials -Action list -ApiVersion 2015-08-01 -Force");
                PowerShellInstance1.AddScript("$username = $creds.Properties.PublishingUserName");
                PowerShellInstance1.AddScript("$password = $creds.Properties.PublishingPassword");
                PowerShellInstance1.AddScript("$filePath = '"+zippath+"'");
                PowerShellInstance1.AddScript("$apiUrl = \"https://test1123412te12121.azurewebsites.net/\"");
                PowerShellInstance1.AddScript("$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((\"{0}:{1}\" -f $username, $password)))");
                PowerShellInstance1.AddScript("$userAgent = \"powershell/1.0\"");
                PowerShellInstance1.AddScript("[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12");
                PowerShellInstance1.AddScript("Invoke-RestMethod -Uri $apiUrl -Headers @{Authorization=(\"Basic {0}\" -f $base64AuthInfo)} -UserAgent $userAgent -Method POST -InFile $filePath -ContentType \"multipart/form-data\" | Out-File -FilePath "+testpath);
                PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();


                //Ml_Resource JSON Logic App Dynamic Values
                //Generating Unique File Name
                var myUniqueFileName3 = $@"{System.DateTime.Now.Ticks}.json";
                //Path of Temp File to be created
                string tempfile3 = Server.MapPath(@"~\App_Data\" + myUniqueFileName3);
                //Path of ML_Resource Template
                string jsonFile2 = Server.MapPath(@"~\App_Data\ML_Resource.json");
                //Copying file
                System.IO.File.Copy(jsonFile2, tempfile3);
                //Changing the Params in TempFile2
                string json2 = System.IO.File.ReadAllText(tempfile3);
                var jObject2 = JObject.Parse(json2);
                jObject2["parameters"]["sqlServer"]["defaultValue"] = dbsrc;
                jObject2["parameters"]["sqlUser"]["defaultValue"] = dbuid;
                jObject2["parameters"]["sqlPassword"]["defaultValue"] = dbpwd;
                jObject2["parameters"]["sqlDatabase"]["defaultValue"] = dbname;
                string output2 = JsonConvert.SerializeObject(jObject2, Formatting.Indented);
                System.IO.File.WriteAllText(tempfile3, output2);

                //Deploying ML_Resource LogicApp
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " +tempfile3);
                Collection<PSObject> tfn1 = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

                //Deleting the Temp File3
                System.IO.File.Delete(tempfile3);


                //Deploying LogicApps_ML
                string TempPath5 = Server.MapPath(@"~\App_Data\LogicApps_ML.json");
                PowerShellInstance1.AddScript("$resourceGroupName = '" + rgname + "'");
                PowerShellInstance1.AddScript("New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile " + TempPath5);
                Collection<PSObject> tfn2 = PowerShellInstance1.Invoke();
                PowerShellInstance1.Commands.Clear();

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