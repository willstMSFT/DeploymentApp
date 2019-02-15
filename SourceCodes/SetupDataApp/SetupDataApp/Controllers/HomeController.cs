using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using SetupDataApp.Models;

namespace SetupDataApp.Controllers
{
    public class HomeController : Controller
    {
        public static string vdbsrc;
        public static string dbname = "bingNews";
        public static string vdbuid;
        public static string vdbpwd;

        
        public ActionResult Index()
        {
            return View();
        }

        
        public ActionResult ReportPage(string dbsrc, string dbuid, string dbpwd)
        {
            vdbsrc = dbsrc;
            vdbuid = dbuid;
            vdbpwd = dbpwd;

            return View();
        }

        public ActionResult HomePage()
        {
            string connectionString = "Server=tcp:"+vdbsrc+".database.windows.net,1433;Initial Catalog="+dbname+";Persist Security Info=False;User ID="+vdbuid+";Password="+vdbpwd+";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";

            var model = new List<MySettings>();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM bpst_news.MySettings", conn);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    var settings = new MySettings();
                    settings.Organization_Name = rdr["Organization_Name"].ToString();
                    settings.AreaOfConcern = rdr["AreaOfConcern"].ToString();
                    settings.Brand_image_URL = rdr["Brand_image_URL"].ToString();
                    settings.Keywords = rdr["Keywords"].ToString();
                    settings.Synonyms = rdr["Synonyms"].ToString();
                    settings.Region = rdr["Region"].ToString();
                    settings.MarketCode = rdr["MarketCode"].ToString();
                    settings.LCL = rdr["LCL"].ToString();
                    settings.UCL = rdr["UCL"].ToString();

                    model.Add(settings);
                }

            }

            return View(model);
        }

        public ActionResult SettingsPage()
        {
            string connectionString = "Server=tcp:"+vdbsrc+".database.windows.net,1433;Initial Catalog="+dbname+";Persist Security Info=False;User ID="+vdbuid+";Password="+vdbpwd+";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";

            var model = new List<MySettings>();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM bpst_news.MySettings", conn);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    var settings = new MySettings();
                    settings.Organization_Name = rdr["Organization_Name"].ToString();
                    settings.AreaOfConcern = rdr["AreaOfConcern"].ToString();
                    settings.Brand_image_URL = rdr["Brand_image_URL"].ToString();
                    settings.Keywords = rdr["Keywords"].ToString();
                    settings.Synonyms = rdr["Synonyms"].ToString();
                    settings.Region = rdr["Region"].ToString();
                    settings.MarketCode = rdr["MarketCode"].ToString();
                    settings.LCL = rdr["LCL"].ToString();
                    settings.UCL = rdr["UCL"].ToString();

                    model.Add(settings);
                }

            }

            return View(model);
        }

        public ActionResult SettingsEditPage()
        {
            string connectionString = "Server=tcp:"+vdbsrc+".database.windows.net,1433;Initial Catalog="+dbname+";Persist Security Info=False;User ID="+vdbuid+";Password="+vdbpwd+";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";

            var model = new List<MySettings>();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM bpst_news.MySettings", conn);
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    var settings = new MySettings();
                    settings.Organization_Name = rdr["Organization_Name"].ToString();
                    settings.AreaOfConcern = rdr["AreaOfConcern"].ToString();
                    settings.Brand_image_URL = rdr["Brand_image_URL"].ToString();
                    settings.Keywords = rdr["Keywords"].ToString();
                    settings.Synonyms = rdr["Synonyms"].ToString();
                    settings.Region = rdr["Region"].ToString();
                    settings.MarketCode = rdr["MarketCode"].ToString();
                    settings.LCL = rdr["LCL"].ToString();
                    settings.UCL = rdr["UCL"].ToString();

                    model.Add(settings);
                }
                
            }

            return View(model);
        }

        public ActionResult UpdatePage(string org, string aoc, string imgurl, string keyword, string synonyms, string lcl, string ucl)
        {
            string connectionString = "Server=tcp:" + vdbsrc + ".database.windows.net,1433;Initial Catalog=" + dbname + ";Persist Security Info=False;User ID=" + vdbuid + ";Password=" + vdbpwd + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=3600";

            var model = new List<MySettings>();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {

                string sql = "UPDATE bpst_news.MySettings SET Organization_Name='" + org + "',AreaOfConcern='" + aoc + "',Brand_image_URL='" + imgurl + "',Keywords='" + keyword + "',Synonyms='" + synonyms + "',LCL='" + lcl + "',UCL='" + ucl + "' WHERE MySettings_ID=1";
                SqlCommand cmd1 = new SqlCommand(sql, conn);
                cmd1.Connection.Open();
                var result = cmd1.ExecuteNonQuery();
                result.ToString();


                SqlCommand cmd = new SqlCommand("SELECT * FROM bpst_news.MySettings", conn);
                cmd1.Connection.Close();
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    var settings = new MySettings();
                    settings.Organization_Name = rdr["Organization_Name"].ToString();
                    settings.AreaOfConcern = rdr["AreaOfConcern"].ToString();
                    settings.Brand_image_URL = rdr["Brand_image_URL"].ToString();
                    settings.Keywords = rdr["Keywords"].ToString();
                    settings.Synonyms = rdr["Synonyms"].ToString();
                    settings.Region = rdr["Region"].ToString();
                    settings.MarketCode = rdr["MarketCode"].ToString();
                    settings.LCL = rdr["LCL"].ToString();
                    settings.UCL = rdr["UCL"].ToString();

                    model.Add(settings);
                }
                cmd.Connection.Close();

                
            }


            return View(model);
        }

        
        public ActionResult SynonymsPage()
        {
            return View();
        }

        public ActionResult KeywordsPage()
        {
            return View();
        }

        public ActionResult LangRegionPage()
        {
            return View();
        }

    }
}