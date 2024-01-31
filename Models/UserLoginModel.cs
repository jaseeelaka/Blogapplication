using System.ComponentModel.DataAnnotations;

namespace Blog_Application.Models
{
    public class UserLoginModel
    {
        
        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email address")]
        public string Email { get; set; }
        [Required(ErrorMessage = "Password is required")]

        public string Password { get; set; }

    }
}
