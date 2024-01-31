using Blog_Application.Filters;
using Blog_Application.Models;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace Blog_Application.Controllers
{
    public class EditorController : Controller
    {
        private readonly IConfiguration _configuration;
        public string connectionString;
        public string WebRootPath = ""; //Website absolute path
        private readonly IWebHostEnvironment _webHostEnvironment;
        public EditorController(IWebHostEnvironment webHostEnvironment, IConfiguration configuration)
        {
            _configuration = configuration;
            connectionString = _configuration.GetConnectionString("SqlConnectionString");
            _webHostEnvironment = webHostEnvironment; // Initialize _webHostEnvironment
            WebRootPath = _webHostEnvironment.WebRootPath;

        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(UserLoginModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();

                        string storedProcedureName = "sp_IsUserLogin";

                        using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;

                            command.Parameters.AddWithValue("@email", model.Email);
                            command.Parameters.AddWithValue("@password", model.Password);
                            command.Parameters.AddWithValue("@account_type", "editor");

                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                // Check if there are rows in the result set
                                if (reader.HasRows && reader.Read()) // Use reader.Read() to advance to the first row
                                {
                                    int userid = reader.GetInt32(reader.GetOrdinal("userid"));
                                    string accountType = reader.GetString(reader.GetOrdinal("account_type"));
                                    int interest = reader.GetInt32(reader.GetOrdinal("interest"));
                                    string username = reader.GetString(reader.GetOrdinal("name"));
                                    // You can use these values as needed
                                    // For example, store them in session
                                    HttpContext.Session.SetInt32("userid", userid);
                                    HttpContext.Session.SetString("AccountType", accountType);
                                    HttpContext.Session.SetInt32("Interest", interest);
                                    HttpContext.Session.SetString("username", username);


                                    return RedirectToAction("home");
                                }
                                else
                                {
                                    TempData["EMessage"] = "Invalid email or password. Please check your credentials and try again.";
                                    return RedirectToAction("Login");
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    TempData["EMessage"] = "An error occurred while processing your request";
                }
            }

            return View(model);
        }

        [CustomAuthenticationFilterAdmin]
        public IActionResult home()
        {
            return View();
        }

        [CustomAuthenticationFilterAdmin]
        public ActionResult logout()
        {
            // Clear session variables
            HttpContext.Session.Clear();

            // Redirect to the login page
            return RedirectToAction("Login");
        }
        [CustomAuthenticationFilterAdmin]
        public IActionResult blogs()
        {
            List<Blog> Blogs = new List<Blog>();
            int? userid = HttpContext.Session.GetInt32("userid");
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_getblogsadmin";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    //command.Parameters.AddWithValue("@userid", userid);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        // Check if there are rows in the result set
                        while (reader.HasRows && reader.Read())
                        {
                            var Blog = new Blog
                            {
                                Blogid = reader.GetInt32(reader.GetOrdinal("Blogid")),
                                userid = reader.GetInt32(reader.GetOrdinal("userid")),
                                title = reader.GetString(reader.GetOrdinal("title")),
                                hiddenImageName1 = reader.GetString(reader.GetOrdinal("hiddenImageName1")),
                                hiddenImageName2 = reader.GetString(reader.GetOrdinal("hiddenImageName2")),
                                hiddenImageName3 = reader.GetString(reader.GetOrdinal("hiddenImageName3")),
                                ispublished = reader.GetInt32(reader.GetOrdinal("ispublished")),
                                createddate = reader.GetDateTime(reader.GetOrdinal("createddate")),
                                username = reader.GetString(reader.GetOrdinal("username")),
                                Catname= reader.GetString(reader.GetOrdinal("Catname"))
                                // Add other properties as needed
                            };

                            Blogs.Add(Blog);
                        }
                    }
                }
            }


            return View(Blogs);
        }
        public IActionResult publish(int a = 0, int blogid = 0)
        {
            string message = "";
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string storedProcedureName = "sp_publishchanges";

                    using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@status", a);
                        command.Parameters.AddWithValue("@blogid", blogid);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            // Check if there are rows in the result set
                            if (reader.HasRows && reader.Read())
                            {
                                message = reader.GetString(reader.GetOrdinal("message"));
                                TempData["Message"] = message;

                            }
                            else
                            {
                                TempData["EMessage"] = "An error occurred while processing your request";

                            }
                        }
                    }
                }


            }

            catch (Exception ex)
            {
                TempData["EMessage"] = "An error occurred while processing your request";
            }
            return RedirectToAction("blogs");
        }

        public IActionResult categories()
        {
            List<Categories> Categories = new List<Categories>();
            int categoryCount = 0;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_SelectCategoryadmin";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.HasRows && reader.Read())
                        {
                            var category = new Categories
                            {
                                Catid = reader.GetInt32(reader.GetOrdinal("Catid")),
                                Catname = reader.GetString(reader.GetOrdinal("Catname")),
                                // Add other properties as needed
                            };

                            Categories.Add(category);
                        }


                    }
                }
            }

            return View(Categories);
        }



    }
}
