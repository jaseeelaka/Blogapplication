public static class TimeHelper
{
    public static string GetTimeAgo(DateTime postedTime)
    {
        TimeSpan timeDifference = DateTime.Now - postedTime;

        if (timeDifference.TotalDays >= 1)
        {
            int days = (int)timeDifference.TotalDays;
            return $"{days} day(s) ago";
        }
        else if (timeDifference.TotalHours >= 1)
        {
            int hours = (int)timeDifference.TotalHours;
            return $"{hours} hour(s) ago";
        }
        else if (timeDifference.TotalMinutes >= 1)
        {
            int minutes = (int)timeDifference.TotalMinutes;
            return $"{minutes} minute(s) ago";
        }
        else
        {
            int seconds = (int)timeDifference.TotalSeconds;
            if(seconds ==0)
            {
                string s = "few";
                return $"{s} second(s) ago";
            }
            else
            {
                return $"{seconds} second(s) ago";


            }

        }
    }
}
