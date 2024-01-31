namespace Blog_Application.Models
{
    public class Comments
    {
        public int commentid { get; set; }

        public int  totalcomment { get; set; }

        public int parentid { get; set; }
        public string comment { get; set; }
       public int commentaddedid { get; set; }
       
      public int blogid { get; set; }

      public string commentaddedname { get; set; }

        public  DateTime  createddate { get; set; }

        public int nestedCommentCount { get; set; }
        public List<Comments> NestedComments { get; set; }

    }
}
