using System.ComponentModel.DataAnnotations;

namespace Blog_Application.Models
{
    public class ProfileModel
    {
        public int userid { get; set; }

        [Required(ErrorMessage = "Name is required")]
        public string name { get; set; }
        public string bio { get; set; }

        public string instalink { get; set; }

        public string facebooklink { get; set; }

        public  string twitterlink { get; set; }

        public string imageName { get; set; }

        public  IFormFile profilePicture { get; set; }






    }
}
