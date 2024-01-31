using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace Blog_Application.Filters
{
    public class AuthorizeLogin
    {
    }

    public class CustomAuthenticationFilterAuthor : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {

            //string j = context.HttpContext.Session.GetString("NameUser");
            string UserType = context.HttpContext.Session.GetString("AccountType");
            if (context.HttpContext.Session.GetString("AccountType") == "editor" || context.HttpContext.Session.GetString("AccountType") == "admin")
            {

                context.Result = new RedirectToRouteResult(
                                        new RouteValueDictionary
                                        {
                                        { "action", "Register" },
                                        { "controller", "Account" }
                                        });

            }
            if (string.IsNullOrEmpty(UserType))
            {
                context.Result = new RedirectToRouteResult(
                                      new RouteValueDictionary
                                      {
                                        { "action", "Register" },
                                        { "controller", "Account" }
                                      });
            }



            base.OnActionExecuting(context);
        }
    }

    public class CustomAuthenticationFilterAdmin : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext context)
        {

            //string j = context.HttpContext.Session.GetString("NameUser");
            string UserType = context.HttpContext.Session.GetString("AccountType");
            if (context.HttpContext.Session.GetString("AccountType") == "author")
            {

                context.Result = new RedirectToRouteResult(
                                        new RouteValueDictionary
                                        {
                                        { "action", "Login" },
                                        { "controller", "Admin" }
                                        });

            }
            if (string.IsNullOrEmpty(UserType))
            {
                context.Result = new RedirectToRouteResult(
                                      new RouteValueDictionary
                                      {
                                        { "action", "Login" },
                                        { "controller", "Admin" }
                                      });
            }



            base.OnActionExecuting(context);
        }
    }


}
