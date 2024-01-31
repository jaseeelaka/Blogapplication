namespace Blog_Application.Models
{
    public class Maincomments
    {
        public List<Comments> Comments { get; set; }

            public List<Comments> nestedComments { get; set; }

    }
}
