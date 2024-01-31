using Blog_Application.Filters;
using Blog_Application.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace Blog_Application.Controllers
{
   
    public class AccountController : Controller
    {
        private readonly IConfiguration _configuration;
        public string connectionString;
        public string WebRootPath = ""; //Website absolute path
        private readonly IWebHostEnvironment _webHostEnvironment;
        public AccountController(IWebHostEnvironment webHostEnvironment,IConfiguration configuration)
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
        
       public IActionResult ourstory()
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
                            command.Parameters.AddWithValue("@account_type", "author");

                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                // Check if there are rows in the result set
                                if (reader.HasRows && reader.Read()) // Use reader.Read() to advance to the first row
                                {
                                    int userid = reader.GetInt32(reader.GetOrdinal("userid"));
                                    string accountType = reader.GetString(reader.GetOrdinal("account_type"));
                                    int interest = reader.GetInt32(reader.GetOrdinal("interest"));
                                    string username= reader.GetString(reader.GetOrdinal("name"));
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


        public ActionResult logout()
        {
            // Clear session variables
            HttpContext.Session.Clear();

            // Redirect to the login page
            return RedirectToAction("Login");
        }



        public IActionResult Register()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Register(UserRegistrationModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {

                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();

                        string storedProcedureName = "sp_InsertUser";

                        using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;

                            command.Parameters.AddWithValue("@name", model.Name);
                            command.Parameters.AddWithValue("@email", model.Email);
                            command.Parameters.AddWithValue("@password", model.Password);
                            command.Parameters.AddWithValue("@account_type", "author");

                            SqlParameter returnMessageParameter = new SqlParameter
                            {
                                ParameterName = "@message",
                                SqlDbType = SqlDbType.NVarChar,
                                Size = 200,
                                Direction = ParameterDirection.Output
                            };
                            command.Parameters.Add(returnMessageParameter);

                            command.ExecuteNonQuery();

                            string returnMessage = returnMessageParameter.Value.ToString();
                            if (returnMessage == "success")
                            {
                                return RedirectToAction("Login");
                            }
                            else
                            {
                                TempData["EMessage"] = returnMessage;
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

        public JsonResult EmailExistance(string Email)
        {
            string resultMessage = "";
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string storedProcedureName = "sp_EmailExistance";

                    using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@email", Email);

                        // Use SqlDataReader to read the result set
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            // Check if there are rows in the result set
                            if (reader.HasRows)
                            {
                                // Read the rows if needed
                                while (reader.Read())
                                {
                                     resultMessage = reader["message"].ToString();
                                    return Json(new { message = resultMessage });
                                }
                            }
                            else
                            {
                                // Handle the case when no rows are returned
                                return Json(new { message = resultMessage });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle exceptions as needed
                return Json(new { error = ex.Message });
            }
            return Json(new { message = resultMessage });
        }

        //[CustomAuthenticationFilterAuthor]
        public IActionResult home()
        {
            int? userid = HttpContext.Session.GetInt32("userid");
            if(userid!=null || userid!= 0)
            {
                HomepageModel model = new HomepageModel();
                int? Interest = HttpContext.Session.GetInt32("Interest");
                if (Interest == 0)
                {
                    return Redirect("get-started/topics");
                }
                else
                {

                    List<Blog> Blogs = new List<Blog>();
                    List<Categories> GeneralCategories = new List<Categories>();
                    List<Categories> SelectedCategories = new List<Categories>();
                    List<SelectListItem> dropDownListGeneralCategories = new List<SelectListItem>();
                    List<SelectListItem> dropDownListSelectedCategories = new List<SelectListItem>();
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();

                        string storedProcedureName = "sp_homedetails";

                        using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;
                             userid = HttpContext.Session.GetInt32("userid");
                            command.Parameters.AddWithValue("@userid", userid);


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

                                    GeneralCategories.Add(category);
                                }

                                reader.NextResult();
                                while (reader.Read() && reader.HasRows)
                                {

                                    var category = new Categories
                                    {
                                        Catid = reader.GetInt32(reader.GetOrdinal("Catid")),
                                        Catname = reader.GetString(reader.GetOrdinal("Catname")),
                                        // Add other properties as needed
                                    };

                                    SelectedCategories.Add(category);


                                }
                                reader.NextResult();
                                while (reader.Read() && reader.HasRows)
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
                                        likecount = reader.GetInt32(reader.GetOrdinal("likecount")),
                                        blogContent = reader.GetString(reader.GetOrdinal("blogContent")),
                                        // Add other properties as needed
                                    };

                                    Blogs.Add(Blog);
                                }





                            }
                        }
                    }
                    model.Blogs = Blogs;
                    model.SelectedCategories = SelectedCategories;
                    model.GeneralCategories = GeneralCategories;
                    if (
                        HttpContext.Session.GetString("Filterapplied") == "true")
                    {
                        if (HttpContext.Session.GetString("FromDate") != null)
                        {
                            DateTime fromDate = DateTime.Parse(HttpContext.Session.GetString("FromDate"));
                            ViewBag.FilterFromDate = fromDate;


                        }
                        else
                        {
                            ViewBag.FilterFromDate = null;
                        }
                        if (HttpContext.Session.GetString("ToDate") != null)
                        {
                            DateTime toDate = DateTime.Parse(HttpContext.Session.GetString("ToDate"));
                        }
                        else
                        {
                            ViewBag.FilterToDate = null;

                        }
                        if (HttpContext.Session.GetInt32("Catid") != null)
                        {
                            ViewBag.FilterCatId = HttpContext.Session.GetInt32("Catid");
                        }
                        else
                        {
                            ViewBag.FilterCatId = null;
                        }

                        ViewBag.Filterapplied = HttpContext.Session.GetString("Filterapplied");


                    }
                    else
                    {
                        // Clear ViewBag if session values are not present
                        // Set ViewBag with session values
                        ViewBag.FilterFromDate = null;
                        ViewBag.FilterToDate = null;
                        ViewBag.FilterCatId = null;
                        ViewBag.Filterapplied = "false";
                    }



                    return View(model);

                }

            }
            else
            {
                HomepageModel model = new HomepageModel();
                List<Blog> Blogs = new List<Blog>();
                List<Categories> GeneralCategories = new List<Categories>();
                List<Categories> SelectedCategories = new List<Categories>();
                List<SelectListItem> dropDownListGeneralCategories = new List<SelectListItem>();
                List<SelectListItem> dropDownListSelectedCategories = new List<SelectListItem>();
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string storedProcedureName = "sp_homedetails";

                    using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        
                        command.Parameters.AddWithValue("@userid", 0);


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

                                GeneralCategories.Add(category);
                            }

                            reader.NextResult();
                            while (reader.Read() && reader.HasRows)
                            {

                                var category = new Categories
                                {
                                    Catid = reader.GetInt32(reader.GetOrdinal("Catid")),
                                    Catname = reader.GetString(reader.GetOrdinal("Catname")),
                                    // Add other properties as needed
                                };

                                SelectedCategories.Add(category);


                            }
                            reader.NextResult();
                            while (reader.Read() && reader.HasRows)
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
                                    likecount = reader.GetInt32(reader.GetOrdinal("likecount")),
                                    blogContent = reader.GetString(reader.GetOrdinal("blogContent")),
                                    // Add other properties as needed
                                };

                                Blogs.Add(Blog);
                            }





                        }
                    }
                }
                model.Blogs = Blogs;
                model.SelectedCategories = SelectedCategories;
                model.GeneralCategories = GeneralCategories;
                if (
                    HttpContext.Session.GetString("Filterapplied") == "true")
                {
                    if (HttpContext.Session.GetString("FromDate") != null)
                    {
                        DateTime fromDate = DateTime.Parse(HttpContext.Session.GetString("FromDate"));
                        ViewBag.FilterFromDate = fromDate;


                    }
                    else
                    {
                        ViewBag.FilterFromDate = null;
                    }
                    if (HttpContext.Session.GetString("ToDate") != null)
                    {
                        DateTime toDate = DateTime.Parse(HttpContext.Session.GetString("ToDate"));
                    }
                    else
                    {
                        ViewBag.FilterToDate = null;

                    }
                    if (HttpContext.Session.GetInt32("Catid") != null)
                    {
                        ViewBag.FilterCatId = HttpContext.Session.GetInt32("Catid");
                    }
                    else
                    {
                        ViewBag.FilterCatId = null;
                    }

                    ViewBag.Filterapplied = HttpContext.Session.GetString("Filterapplied");


                }
                else
                {
                    // Clear ViewBag if session values are not present
                    // Set ViewBag with session values
                    ViewBag.FilterFromDate = null;
                    ViewBag.FilterToDate = null;
                    ViewBag.FilterCatId = null;
                    ViewBag.Filterapplied = "false";
                }



                return View(model);
            }
            
            
        }

        [HttpGet]
        public IActionResult getcategoryblogs(int categoryId,int pagenumber, string sortingoption= "newest")
        {

            string orderby = "";
            if(sortingoption== "newest")
            {
                 orderby = "DESC";
            }
            else
            {
                orderby = "ASC";
            }
            List<Blog> blogs = new List<Blog>();
            HomepageModel model = new HomepageModel();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_getcategoryblogs";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@categoryId", categoryId);
                    command.Parameters.AddWithValue("@orderby", orderby);
                    //command.Parameters.AddWithValue("@categoryId", categoryId);
                    //command.Parameters.AddWithValue("@categoryId", categoryId);


                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read() && reader.HasRows)
                        {
                            var blog = new Blog
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
                                likecount = reader.GetInt32(reader.GetOrdinal("likecount")),
                                blogContent = reader.GetString(reader.GetOrdinal("blogContent")),
                                // Add other properties as needed
                            };

                            blogs.Add(blog);
                        }
                    }
                }
            }

            //model.Blogs = blogs;
            // Perform pagination
            var  TotalItems = blogs.Count;
            var  pageSize = 1;
            var totalPages = (int)Math.Ceiling((double)TotalItems / pageSize);
            var paginatedBlogs = blogs.Skip((pagenumber - 1) * pageSize).Take(pageSize).ToList();

            

            model.Blogs = paginatedBlogs;
            model.TotalPages = totalPages;
            model.CurrentPage = pagenumber;
            model.PageSize = pageSize;
            model.CategoryId = categoryId;
            model.ActionName = "getcategoryblogs";
            model.TotalItems = TotalItems;
            return PartialView("_BlogContainer", model);
        }

        [HttpGet]
        public IActionResult search(int pagenumber, string searchkeyword=null,string sortingoption="newest")
        {

            string orderby = "";
            if (sortingoption == "newest")
            {
                orderby = "DESC";
            }
            else
            {
                orderby = "ASC";
            }
            List<Blog> blogs = new List<Blog>();
            HomepageModel model = new HomepageModel();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_searchblogs";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@searchkeyword", searchkeyword);
                    command.Parameters.AddWithValue("@orderby", orderby);


                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read() && reader.HasRows)
                        {
                            var blog = new Blog
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
                                likecount = reader.GetInt32(reader.GetOrdinal("likecount")),
                                blogContent = reader.GetString(reader.GetOrdinal("blogContent")),
                                // Add other properties as needed
                            };

                            blogs.Add(blog);
                        }
                    }
                }
            }

            //model.Blogs = blogs;
            // Perform pagination
            var TotalItems = blogs.Count;
            var pageSize = 1;
            var totalPages = (int)Math.Ceiling((double)TotalItems / pageSize);
            var paginatedBlogs = blogs.Skip((pagenumber - 1) * pageSize).Take(pageSize).ToList();



            model.Blogs = paginatedBlogs;
            model.TotalPages = totalPages;
            model.CurrentPage = pagenumber;
            model.PageSize = pageSize;
            model.CategoryId = 0;
            model.ActionName = "search";
            model.TotalItems = TotalItems;
            return PartialView("_BlogContainer", model);


        }
            

        [CustomAuthenticationFilterAuthor]
       
       
        [Route("Account/get-started/topics")]
        public IActionResult SelectCategory()
        {
            List<Categories> Categories = new List<Categories>();
            int categoryCount = 0;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_SelectCategory";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    int? userid = HttpContext.Session.GetInt32("userid");
                    command.Parameters.AddWithValue("@userid", userid);
                    command.Parameters.AddWithValue("@Blogid", 0);
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.HasRows && reader.Read() )
                        {
                            var category = new Categories
                            {
                                Catid = reader.GetInt32(reader.GetOrdinal("Catid")),
                                Catname = reader.GetString(reader.GetOrdinal("Catname")),
                                // Add other properties as needed
                            };

                            Categories.Add(category);
                        }

                        reader.NextResult();

                        // Check if there are rows in the result set
                        if (reader.HasRows && reader.Read())
                        {
                            // Read the output parameter value
                             categoryCount = reader.GetInt32(reader.GetOrdinal("categorycount"));
                        }

                    }
                }
            }
            ViewBag.categoryCount = categoryCount;
            return View(Categories);
        }
   
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult SelectedCategory(List<int> Catid)
        {
            int? userid = HttpContext.Session.GetInt32("userid");
            if (Catid != null && Catid.Any())
            {
                try
                {
                    string categoryIdsString = string.Join(",", Catid);

                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();

                        string storedProcedureName = "sp_InsertSelectedCategories";

                        using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;

                            command.Parameters.AddWithValue("@userid", userid);
                            command.Parameters.AddWithValue("@CategoryIds", categoryIdsString);

                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                // Check if there are rows in the result set
                                if (reader.HasRows && reader.Read()) // Use reader.Read() to advance to the first row
                                {
                                    int interest = reader.GetInt32(reader.GetOrdinal("interest"));

                                    HttpContext.Session.SetInt32("Interest", interest);
                                    if (interest == 1)
                                    {
                                        return RedirectToAction("home");
                                    }
                                }
                                else
                                {
                                    TempData["EMessage"] = "Try again";
                                    return Redirect("get-started/topics");
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    TempData["EMessage"] = "An error occurred while processing your request";
                    return Redirect("get-started/topics");
                }
            }

            TempData["EMessage"] = "Please select at least one category";
            return Redirect("get-started/topics");
        }

        [CustomAuthenticationFilterAuthor]
        public IActionResult profile()
        {
            int? userid = HttpContext.Session.GetInt32("userid");
            var model = new ProfileModel();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_getprofileinfo";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@userid", userid);
                    

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                      
                        if (reader.HasRows && reader.Read()) 
                        {
                            model.userid = reader.GetInt32(reader.GetOrdinal("userid"));
                            model.bio = reader.GetString(reader.GetOrdinal("bio"));
                            model.instalink = reader.GetString(reader.GetOrdinal("instalink"));
                            model.facebooklink = reader.GetString(reader.GetOrdinal("fblink"));
                            model.twitterlink = reader.GetString(reader.GetOrdinal("twitterlink"));
                            model.imageName = reader.GetString(reader.GetOrdinal("photo"));
                           model.name= reader.GetString(reader.GetOrdinal("name"));

                            return View(model);
                        }
                        else
                        {
                            return View(model);
                        }
                    }
                }
            }


            return View(model);

        }
        [CustomAuthenticationFilterAuthor]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult profile(ProfileModel model, IFormFile profilePicture)
        {
            
            //if (ModelState.IsValid)
            //{
                try
                {
                    string imagePath = "";
                    if (profilePicture != null)
                    {
                         imagePath = SaveProfilePicture(profilePicture);
                    }
                    else
                    {
                        imagePath = model.imageName;
                    }

                    model.imageName = imagePath;
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();

                        string storedProcedureName = "sp_updateprofile";

                        using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;

                            command.Parameters.AddWithValue("@userid", model.userid);
                            command.Parameters.AddWithValue("@instalink", model.instalink);
                            command.Parameters.AddWithValue("@facebooklink", model.facebooklink);
                            command.Parameters.AddWithValue("@twitterlink", model.twitterlink);
                            command.Parameters.AddWithValue("@photo", model.imageName);
                            command.Parameters.AddWithValue("@bio", model.bio);
                            command.Parameters.AddWithValue("@name", model.name);

                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                // Check if there are rows in the result set
                                if (reader.HasRows && reader.Read()) // Use reader.Read() to advance to the first row
                                {
                                    model.userid = reader.GetInt32(reader.GetOrdinal("userid"));
                                    model.bio = reader.GetString(reader.GetOrdinal("bio"));
                                    model.instalink = reader.GetString(reader.GetOrdinal("instalink"));
                                    model.facebooklink = reader.GetString(reader.GetOrdinal("fblink"));
                                    model.twitterlink = reader.GetString(reader.GetOrdinal("twitterlink"));
                                    model.imageName = reader.GetString(reader.GetOrdinal("photo"));
                                    TempData["Message"] = "Profile Updated Scccessfully";
                                  
                                    return View(model);
                                }
                                else
                                {
                                    TempData["EMessage"] = "An error occurred while processing your request.Try again";
                                    return View(model);
                                }
                            }
                        }
                    }




                    
                    
                }
                catch (Exception ex)
                {
                    TempData["EMessage"] = "An error occurred while processing your request.Try again";
                    return View(model);
                }
            //}

            return View(model);
        }


        [CustomAuthenticationFilterAuthor]
        public IActionResult blog(int Blogid = 0)
        {
            Blog model = new Blog();
            List<Categories> Categories = new List<Categories>();
            List<SelectListItem> dropDownList = new List<SelectListItem>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_SelectCategory";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    int? userid = HttpContext.Session.GetInt32("userid");
                    command.Parameters.AddWithValue("@userid", userid);
                    command.Parameters.AddWithValue("@Blogid", Blogid); // Add Blogid parameter

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

                        // Check if Blogid is not 0, then read the third SELECT query
                        if (Blogid != 0 && reader.NextResult() && reader.NextResult() && reader.Read())
                        {
                            model.Blogid = reader.GetInt32(reader.GetOrdinal("Blogid"));
                            model.userid = reader.GetInt32(reader.GetOrdinal("userid"));
                            model.title = reader.GetString(reader.GetOrdinal("title"));
                            model.blogContent = reader.GetString(reader.GetOrdinal("blogcontent"));
                            model.hiddenImageName1 = reader.GetString(reader.GetOrdinal("hiddenImageName1"));
                            model.hiddenImageName2 = reader.GetString(reader.GetOrdinal("hiddenImageName2"));
                            model.hiddenImageName3 = reader.GetString(reader.GetOrdinal("hiddenImageName3"));
                            model.Catid = reader.GetInt32(reader.GetOrdinal("Catid"));
                            model.tags = reader.GetString(reader.GetOrdinal("tags"));
                            model.ispublished = reader.GetInt32(reader.GetOrdinal("ispublished"));
                            // Add other properties as needed
                        }
                    }
                }
            }

            if (Categories.Count > 0)
            {
                foreach (var item in Categories)
                {
                    dropDownList.Add(new SelectListItem
                    {
                        Value = item.Catid.ToString(),
                        Text = item.Catname,
                    });
                }
            }

            ViewBag.Categories = dropDownList;

            return View(model);
        }


      
            [CustomAuthenticationFilterAuthor]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult blog(Blog model,IFormFile featuredImage1, IFormFile featuredImage2, IFormFile featuredImage3)
        {

          


            
                try
                {
                    string featuredImage1Path = "";
                    string featuredImage2Path = "";
                    string featuredImage3Path = "";
                    int? userid = HttpContext.Session.GetInt32("userid");
                    if (featuredImage1 != null)
                    {
                        featuredImage1Path = SaveProfilePicture(featuredImage1);
                    }
                    else
                    {
                    if (!string.IsNullOrEmpty(model.hiddenImageName1))
                    {
                        featuredImage1Path = model.hiddenImageName1;
                    }
                       
                    }
                    if (featuredImage2 != null)
                    {
                        featuredImage2Path = SaveProfilePicture(featuredImage2);
                    }
                    else
                    {
                    if (!string.IsNullOrEmpty(model.hiddenImageName2))
                    {
                        featuredImage2Path = model.hiddenImageName2;
                    }

                    }
                    if (featuredImage3 != null)
                    {
                        featuredImage3Path = SaveProfilePicture(featuredImage3);
                    }
                    else
                    {
                    if (!string.IsNullOrEmpty(model.hiddenImageName3))
                    {
                        featuredImage3Path = model.hiddenImageName3;
                    }

                    }

                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();

                        string storedProcedureName = "sp_addupdateblog";

                        using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;

                            command.Parameters.AddWithValue("@userid", userid);
                            command.Parameters.AddWithValue("@featuredImage1Path", featuredImage1Path);
                            command.Parameters.AddWithValue("@featuredImage2Path", featuredImage2Path);
                            command.Parameters.AddWithValue("@featuredImage3Path", featuredImage3Path);
                            command.Parameters.AddWithValue("@tags", model.tags);
                            command.Parameters.AddWithValue("@blogContent", model.blogContent);
                            command.Parameters.AddWithValue("@Catid", model.Catid);
                            command.Parameters.AddWithValue("@title", model.title);
                            command.Parameters.AddWithValue("@Blogid", model.Blogid);
                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                // Check if there are rows in the result set
                                if (reader.HasRows && reader.Read()) // Use reader.Read() to advance to the first row
                                {
                                    
                                    string message = reader.GetString(reader.GetOrdinal("message"));
                                    if(message == "success")
                                    {
                                    if (model.Blogid == 0)
                                    {
                                        TempData["Message"] = "Blog published successfully. It can be seen by users once admin approves it.";

                                    }
                                    else
                                    {
                                        TempData["Message"] = "Blog edited successfully. It can be seen by users once admin approves it.";

                                    }
                                    return RedirectToAction("myblogs");
                                    }
                                    
                                   
                                }
                                else
                                {
                                    TempData["EMessage"] = "An error occurred while processing your request.Try again";
                                    return View(model);
                                }
                            }
                        }
                    }






                }
                catch (Exception ex)
                {
                    TempData["EMessage"] = "An error occurred while processing your request.Try again";
                    
                }
                
            

           

            List<Categories> Categories = new List<Categories>();
            List<SelectListItem> dropDownList = new List<SelectListItem>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_SelectCategory";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    int? userid = HttpContext.Session.GetInt32("userid");
                    command.Parameters.AddWithValue("@userid", userid);
                    command.Parameters.AddWithValue("@Blogid", 0);
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

            if (Categories.Count > 0)
            {
                foreach (var item in Categories)
                {
                    dropDownList.Add(new SelectListItem
                    {
                        Value = item.Catid.ToString(),
                        Text = item.Catname,
                    });
                }
            }

            ViewBag.Categories = dropDownList;

            return View(model);
        }


        [CustomAuthenticationFilterAuthor]
        public IActionResult myblogs()
        {
            List<Blog> Blogs = new List<Blog>();
            int? userid = HttpContext.Session.GetInt32("userid");
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_getblogs";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@userid", userid);

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
                                createddate= reader.GetDateTime(reader.GetOrdinal("createddate")),
                                username= reader.GetString(reader.GetOrdinal("username")),
                                // Add other properties as needed
                            };

                            Blogs.Add(Blog);
                        }
                    }
                }
            }


            return View(Blogs);
        }

        [CustomAuthenticationFilterAuthor]
        public IActionResult Detail(int blogid = 0)
        {
            HomepageModel model = new HomepageModel();
            List<Comments> comments = new List<Comments>();
            int count = 0;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_blogdetails";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Blogid", blogid); // Add Blogid parameter
                   
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        // Read the first result set for blog details
                        if (reader.HasRows && reader.Read())
                        {
                            model.Blog = new Blog
                            {
                                Blogid = reader.GetInt32(reader.GetOrdinal("Blogid")),
                                userid = reader.GetInt32(reader.GetOrdinal("userid")),
                                title = reader.GetString(reader.GetOrdinal("title")),
                                blogContent = reader.GetString(reader.GetOrdinal("blogcontent")),
                                hiddenImageName1 = reader.GetString(reader.GetOrdinal("hiddenImageName1")),
                                hiddenImageName2 = reader.GetString(reader.GetOrdinal("hiddenImageName2")),
                                hiddenImageName3 = reader.GetString(reader.GetOrdinal("hiddenImageName3")),
                                Catid = reader.GetInt32(reader.GetOrdinal("Catid")),
                                tags = reader.GetString(reader.GetOrdinal("tags")),
                                ispublished = reader.GetInt32(reader.GetOrdinal("ispublished")),
                                createddate = reader.GetDateTime(reader.GetOrdinal("createddate")),
                                username = reader.GetString(reader.GetOrdinal("username")),
                                Catname = reader.GetString(reader.GetOrdinal("Catname"))
                            };
                        }

                        // Move to the next result set for comments
                        reader.NextResult();

                        // Read the second result set for comments
                        while (reader.Read())
                        {
                            Comments comment = new Comments
                            {
                                commentid = reader.GetInt32(reader.GetOrdinal("commentid")),
                                comment = reader.GetString(reader.GetOrdinal("comment")),
                                commentaddedid = reader.GetInt32(reader.GetOrdinal("commentaddedid")),
                                blogid = reader.GetInt32(reader.GetOrdinal("blogid")),
                                commentaddedname = reader.GetString(reader.GetOrdinal("commentaddedname")),
                                createddate = reader.GetDateTime(reader.GetOrdinal("createddate")),
                                nestedCommentCount = reader.GetInt32(reader.GetOrdinal("nestedCommentCount"))
                                
                                // You can add other properties as needed
                            };
                            count = count + comment.nestedCommentCount;
                            comments.Add(comment); // Add fetched comment to the model
                        }
                    }
                }
            }
            
            model.Comments = comments;
            ViewBag.count = count;
            return View(model);
        }



        [CustomAuthenticationFilterAuthor]
        public IActionResult delete(int blogid = 0)
        {
            try
            {

                if (blogid!= 0)
                {
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        connection.Open();

                        string storedProcedureName = "sp_deleteblog";

                        using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;

                            command.Parameters.AddWithValue("@Blogid", blogid); // Add Blogid parameter

                            using (SqlDataReader reader = command.ExecuteReader())
                            {



                                if (blogid != 0 && reader.HasRows && reader.Read())
                                {
                                    string Message = reader.GetString(reader.GetOrdinal("Message"));
                                    TempData["Message"] = Message;
                                }
                                else
                                {
                                    TempData["EMessage"] = "An error occurred while processing your request";
                                }
                            }
                        }
                    }

                }
                else
                {
                    TempData["EMessage"] = "You can't delete this blog";


                }

            }
            catch(Exception ex)
            {
                TempData["EMessage"] = "An error occurred while processing your request";


            }
          



            return RedirectToAction("myblogs");
        }


       
        [HttpGet]
        public IActionResult filterblog(int pagenumber,int Catid, DateTime? FromDate=null, DateTime? ToDate=null, string sortingoption= "newest")
        {

            string orderby = "";
            if (sortingoption == "newest")
            {
                orderby = "DESC";
            }
            else
            {
                orderby = "ASC";
            }
            List<Blog> blogs = new List<Blog>();
            HomepageModel model = new HomepageModel();
            string fromDateStr = FromDate?.ToString("yyyy-MM-dd HH:mm:ss");
            string toDateStr = ToDate?.ToString("yyyy-MM-dd HH:mm:ss");
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                
                connection.Open();

                string storedProcedureName = "sp_filterblogs";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@categoryId", Catid);
                    command.Parameters.AddWithValue("@FromDate", fromDateStr);
                    command.Parameters.AddWithValue("@ToDate", toDateStr);
                    command.Parameters.AddWithValue("@orderby", orderby);


                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read() && reader.HasRows)
                        {
                            var blog = new Blog
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
                                likecount = reader.GetInt32(reader.GetOrdinal("likecount")),
                                blogContent = reader.GetString(reader.GetOrdinal("blogContent")),
                                // Add other properties as needed
                            };

                            blogs.Add(blog);
                        }
                    }
                }
            }

            //model.Blogs = blogs;
            // Perform pagination
            var TotalItems = blogs.Count;
            var pageSize = 1;
            var totalPages = (int)Math.Ceiling((double)TotalItems / pageSize);
            var paginatedBlogs = blogs.Skip((pagenumber - 1) * pageSize).Take(pageSize).ToList();



            model.Blogs = paginatedBlogs;
            model.TotalPages = totalPages;
            model.CurrentPage = pagenumber;
            model.PageSize = pageSize;
            model.CategoryId = Catid;
            model.ActionName = "filterblog";
            model.TotalItems = TotalItems;
            return PartialView("_BlogContainer", model);
        }

       

        [HttpPost]
        public IActionResult AddComment(string comment,int? commentaddedid,int blogid,int parentid)
        {
            commentaddedid = HttpContext.Session.GetInt32("userid");
            List<Comments> comments = new List<Comments>();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {

                connection.Open();
                
                string storedProcedureName = "sp_AddCommentGetcomments";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                  
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@comment", comment);
                    command.Parameters.AddWithValue("@commentaddedid", commentaddedid);
                    command.Parameters.AddWithValue("@blogid", blogid);
                    command.Parameters.AddWithValue("@parentid", parentid);

                    

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.HasRows && reader.Read())
                        {
                            Comments commen = new Comments
                            {
                                commentid = reader.GetInt32(reader.GetOrdinal("commentid")),
                                comment = reader.GetString(reader.GetOrdinal("comment")),
                                commentaddedid = reader.GetInt32(reader.GetOrdinal("commentaddedid")),
                                blogid = reader.GetInt32(reader.GetOrdinal("blogid")),
                                commentaddedname = reader.GetString(reader.GetOrdinal("commentaddedname")),
                                createddate = reader.GetDateTime(reader.GetOrdinal("createddate")),
                                 nestedCommentCount = reader.GetInt32(reader.GetOrdinal("nestedCommentCount"))

                                // You can add other properties as needed
                            };


                            comments.Add(commen);
                        }
                        
                        return PartialView("_PartialComments", comments);






                    }
                }
            }




        }


        [HttpPost]
        public IActionResult AddCommentnested(string comment, int? commentaddedid, int blogid, int parentid)
        {
             commentaddedid= HttpContext.Session.GetInt32("userid");
            List<Comments> nestedComments = new List<Comments>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_AddCommentGetcomments";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@comment", comment);
                    command.Parameters.AddWithValue("@commentaddedid", commentaddedid);
                    command.Parameters.AddWithValue("@blogid", blogid);
                    command.Parameters.AddWithValue("@parentid", parentid);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.HasRows && reader.Read())
                        {
                            Comments commen = new Comments
                            {
                                commentid = reader.GetInt32(reader.GetOrdinal("commentid")),
                                comment = reader.GetString(reader.GetOrdinal("comment")),
                                commentaddedid = reader.GetInt32(reader.GetOrdinal("commentaddedid")),
                                blogid = reader.GetInt32(reader.GetOrdinal("blogid")),
                                commentaddedname = reader.GetString(reader.GetOrdinal("commentaddedname")),
                                createddate = reader.GetDateTime(reader.GetOrdinal("createddate")),
                                nestedCommentCount = reader.GetInt32(reader.GetOrdinal("nestedCommentCount"))
                                // You can add other properties as needed
                            };

                            nestedComments.Add(commen);
                        }
                    }
                }
            }

            // Generate HTML for nested comments
            string nestedCommentsHtml = RenderNestedComments(nestedComments);

            // Return the nested comments HTML as part of the JSON response
            return Json(new { nestedCommentsHtml });
        }

        public IActionResult nestedcommentunder(string commentId,int blogid)
        {
            List<Comments> nestedComments = new List<Comments>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string storedProcedureName = "sp_nestedcommentunder";

                using (SqlCommand command = new SqlCommand(storedProcedureName, connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@commentId", commentId);
                    command.Parameters.AddWithValue("@blogid", blogid);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.HasRows && reader.Read())
                        {
                            Comments commen = new Comments
                            {
                                commentid = reader.GetInt32(reader.GetOrdinal("commentid")),
                                comment = reader.GetString(reader.GetOrdinal("comment")),
                                commentaddedid = reader.GetInt32(reader.GetOrdinal("commentaddedid")),
                                blogid = reader.GetInt32(reader.GetOrdinal("blogid")),
                                commentaddedname = reader.GetString(reader.GetOrdinal("commentaddedname")),
                                createddate = reader.GetDateTime(reader.GetOrdinal("createddate")),
                                nestedCommentCount = reader.GetInt32(reader.GetOrdinal("nestedCommentCount"))
                                // You can add other properties as needed
                            };

                            nestedComments.Add(commen);
                        }
                    }
                }
            }

            // Generate HTML for nested comments
            string nestedCommentsHtml = RenderNestedComments(nestedComments);

            // Return the nested comments HTML as part of the JSON response
            return Json(new { nestedCommentsHtml });
        }



        // Helper method to render nested comments HTML
        private string RenderNestedComments(List<Comments> nestedComments)
        {
            if (nestedComments != null && nestedComments.Any())
            {
                StringBuilder result = new StringBuilder();

                foreach (var nestedComment in nestedComments)
                {
                    result.AppendLine("<li>");
                    result.AppendLine("    <div class='nested-comment-content'>");
                    result.AppendLine($"        <span class='user-initial-circle'>{nestedComment.commentaddedname.Substring(0, 1).ToUpper()}</span>");
                    result.AppendLine($"        <span>{nestedComment.commentaddedname}</span>");
                    result.AppendLine($"        <span class='comment-time'>{TimeHelper.GetTimeAgo(nestedComment.createddate)}</span>");
                    result.AppendLine($"        <p>{nestedComment.comment}</p>");
                    result.AppendLine("        <div>");
                    result.AppendLine($"            <button onclick='likeComment({nestedComment.commentid})' style='background: none; border: none;'>");
                    result.AppendLine("                <i class='far fa-thumbs-up'></i>");
                    result.AppendLine("            </button>");
                    result.AppendLine("            |");
                    result.AppendLine($"            {(nestedComment.nestedCommentCount)}<button class='reply-btn' onclick='toggleReply({nestedComment.commentid},{nestedComment.blogid})' style='background: none; border: none;'>");
                    result.AppendLine("                <i class='far fa-comment'></i>");
                    result.AppendLine("            </button>");
                    result.AppendLine("        </div>");

                    // No need to include textarea and reply container section here

                    result.AppendLine("    </div>");
                    result.AppendLine("</li>");

                    // Recursively call RenderNestedComments to render nested nested comments
                    result.AppendLine(RenderNestedComments(nestedComment.NestedComments));
                }

                return result.ToString();
            }

            // Return an empty string if there are no nested comments
            return "";
        }

        private string SaveProfilePicture(IFormFile postedfile)
        {
     
             string fileUrl = "";
            if (postedfile!=null)
            {

                
                String fileID = GetUniqueID();
                String filePath = "/uploads/images/";
                 fileUrl = filePath + fileID + ".jpg";
                
                SaveFile(postedfile: postedfile, fileUrl: fileUrl, filePath: WebRootPath + filePath.Replace("/", @"\"), WebRootPath, imgWidth: 1000, imgHeight: 1000);




                
                return fileUrl;
            }

            return fileUrl;
        }




        public void SaveFile(IFormFile postedfile, string fileUrl, string filePath, string webRootPath, int imgWidth = 1000, int imgHeight = 1000)
        {
            
            String fullfilePath = webRootPath + fileUrl;
            if (Directory.Exists(filePath))
            {
            }
            else
            {
                Directory.CreateDirectory(filePath);
            }
            using (FileStream stream = new FileStream(fullfilePath, FileMode.Create))
            {
                postedfile.CopyTo(stream);
            }
        }

        public string GetUniqueID()
        {
            string ID = "";
            ID = "" + DateTime.Now.Year + "" + DateTime.Now.Month + "" + DateTime.Now.Day + "" + DateTime.Now.Hour + DateTime.Now.Minute + "" + DateTime.Now.Second + "" + DateTime.Now.Millisecond;
            return ID;
        }

        




    }
}
