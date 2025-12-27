using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class courses : Page
    {
        public class Course
        {
            public int CourseID { get; set; }
            public string Title { get; set; }
            public string Category { get; set; }
            public string BadgeClass { get; set; }
            public string Price { get; set; }
            public double PriceValue { get; set; }
            public string Rating { get; set; }
            public string Description { get; set; }
            public string ImageUrl { get; set; }
            public string InstructorName { get; set; }
            public string InstructorImg { get; set; }
            public int PopularityScore { get; set; }
            public int Progress { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                hfCategory.Value = "All";
                BindCourses();
            }
        }

        private void BindCourses()
        {
            var courses = GetCourses().AsQueryable();

            // Search
            string search = txtSearch.Text.Trim().ToLower();
            if (!string.IsNullOrEmpty(search))
            {
                courses = courses.Where(c => c.Title.ToLower().Contains(search) || c.Category.ToLower().Contains(search));
            }

            // Category filter
            string category = hfCategory.Value;
            if (!string.IsNullOrEmpty(category) && category != "All")
            {
                courses = courses.Where(c => c.Category == category);
            }

            // Sorting
            switch (ddlSort.SelectedValue)
            {
                case "PriceAsc": courses = courses.OrderBy(c => c.PriceValue); break;
                case "PriceDesc": courses = courses.OrderByDescending(c => c.PriceValue); break;
                case "Newest": courses = courses.OrderByDescending(c => c.CourseID); break;
                default: courses = courses.OrderByDescending(c => c.PopularityScore); break;
            }

            rptCourses.DataSource = courses.ToList();
            rptCourses.DataBind();
            litCount.Text = courses.Count().ToString();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindCourses();
        }

        protected void Filter_Changed(object sender, EventArgs e)
        {
            BindCourses();
        }

        protected void Category_Click(object sender, EventArgs e)
        {
            var lb = (LinkButton)sender;
            hfCategory.Value = lb.Text;

            // Reset all pills
            foreach (Control c in lb.Parent.Controls)
            {
                if (c is LinkButton link) link.CssClass = "category-pill";
            }
            lb.CssClass = "category-pill active";

            BindCourses();
        }

        private List<Course> GetCourses()
        {
            return new List<Course>
    {
        new Course
        {
            CourseID = 1,
            Title = "Full-Stack Web Development",
            Category = "Web Dev",
            BadgeClass = "text-primary",
            Price = "$49.99",
            PriceValue = 49.99,
            Rating = "4.9",
            Description = "Learn HTML, CSS, JS & C#.",
            ImageUrl = "https://etlhive.com/wp-content/uploads/2024/07/fullstackdevelopmentsurat.webp",
            InstructorName = "Shreeya Gautam",
            InstructorImg = "https://i.pravatar.cc/150?u=1",
            PopularityScore = 95,
            Progress = GetUserProgress(1)
        },
        new Course
        {
            CourseID = 2,
            Title = "AI & Machine Learning Pro",
            Category = "AI/ML",
            BadgeClass = "text-purple",
            Price = "$89.99",
            PriceValue = 89.99,
            Rating = "4.8",
            Description = "Deep dive into Neural Networks & Python.",
            ImageUrl = "https://img.freepik.com/free-vector/gradient-artificial-intelligence-twitter-header_23-2150330599.jpg?semt=ais_hybrid&w=740&q=80",
            InstructorName = "Bikhul Koirala",
            InstructorImg = "https://i.pravatar.cc/150?u=2",
            PopularityScore = 98,
            Progress = GetUserProgress(2)
        },
        new Course
        {
            CourseID = 3,
            Title = "Cybersecurity Essentials",
            Category = "Cyber",
            BadgeClass = "text-danger",
            Price = "$59.99",
            PriceValue = 59.99,
            Rating = "4.7",
            Description = "Learn ethical hacking basics.",
            ImageUrl = "data:image/jpeg;base64,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",
            InstructorName = "Niraj Bhandari",
            InstructorImg = "https://i.pravatar.cc/150?u=3",
            PopularityScore = 80,
            Progress = GetUserProgress(3)
        },
        new Course
        {
            CourseID = 4,
            Title = "UI/UX Advanced Design",
            Category = "Design",
            BadgeClass = "text-success",
            Price = "$39.00",
            PriceValue = 39.00,
            Rating = "4.9",
            Description = "Create stunning interfaces.",
            ImageUrl = "https://www.creative-tim.com/blog/content/images/2022/07/UX-design-courses.jpg",
              InstructorName = "Rohit Acharya",
            InstructorImg = "https://i.pravatar.cc/150?u=4",
            PopularityScore = 90,
            Progress = GetUserProgress(4)
        },
        new Course
        {
            CourseID = 5,
            Title = "Business Growth & Strategy",
            Category = "Business",
            BadgeClass = "text-warning",
            Price = "$69.99",
            PriceValue = 69.99,
            Rating = "4.8",
            Description = "Master business strategy.",
            ImageUrl = "https://c8.alamy.com/comp/2C7RJGN/business-growth-landing-page-vector-template-entrepreneurship-coaching-courses-website-homepage-interface-idea-success-achievement-education-web-banner-cartoon-concept-2C7RJGN.jpg",
            InstructorName = "Anwesha Stapit",
            InstructorImg = "https://i.pravatar.cc/150?u=5",
            PopularityScore = 88,
            Progress = GetUserProgress(5)
        },
        new Course
        {
            CourseID = 6,
            Title = "IT Fundamentals",
            Category = "IT",
            BadgeClass = "text-info",
            Price = "$29.99",
            PriceValue = 29.99,
            Rating = "4.6",
            Description = "Learn IT infrastructure basics.",
            ImageUrl = "https://www.genuinesolutionguru.com/gsg_img/IT_Fundamental_banner.jpg",
            InstructorImg = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvFbv3_wBBjVBrVgwJyEmtKGjALgpzOqy4dQ&s",
              InstructorName = "Nishant Shrestha",
            PopularityScore = 85,
            Progress = GetUserProgress(6)
        }
    };
        }



        private int GetUserProgress(int courseId)
        {
            if (Session["UserID"] == null) return 0;
            Random rnd = new Random(courseId);
            return rnd.Next(10, 100);
        }
    }
}