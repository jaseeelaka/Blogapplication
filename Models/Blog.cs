using System.ComponentModel.DataAnnotations;

namespace Blog_Application.Models
{
    public class Blog
    {
        public int userid { get; set; }
        public  int Blogid { get; set; }
        [Required(ErrorMessage = "Title is Required")]
        public string title { get; set; }

  
        public string tags { get; set; }

        [Required(ErrorMessage = "This field is Required")]
        public string hiddenImageName1 { get; set; }

        public string hiddenImageName2 { get; set; }

        public string hiddenImageName3 { get; set; }

        [Required(ErrorMessage = "Category is required")]
        public int Catid { get; set; }

        [Required(ErrorMessage = "This field is Required")]
        public string blogContent { get; set; }


        public IFormFile featuredImage1 { get; set; }
        public IFormFile featuredImage2 { get; set; }
        public IFormFile featuredImage3 { get; set; }

        public int ispublished { get; set; }

        public string createdby { get; set; }

        public DateTime createddate { get; set; }

        public string username { get; set; }

        public string Catname { get; set; }

        public int likecount { get; set; }
    }
}
