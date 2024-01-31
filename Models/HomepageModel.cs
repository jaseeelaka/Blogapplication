namespace Blog_Application.Models
{
    public class HomepageModel
    {
        public List<Categories> SelectedCategories { get; set; }
        public List<Blog> Blogs { get; set; }

        //public Maincomments Maincomments { get; set; }
       public  List<Comments> Comments { get; set; }
        public  Blog Blog { get; set; }
        public List<Categories> GeneralCategories { get; set; }
        public int TotalItems { get; set; } // Total number of blogs
        public int TotalPages { get; set; } // Total number of pages
        public int CurrentPage { get; set; } // Current page number

        public int pagenumber { get; set; }
        public int PageSize { get; set; } // Number of blogs per page
        public int CategoryId { get; set; } // Current category ID

        public string ActionName { get; set; }


        public string SearchValue { get; set; }
}
}
