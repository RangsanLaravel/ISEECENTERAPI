using Microsoft.AspNetCore.Mvc;
using ReportCenter.Models;
using RestSharp;
using System.Diagnostics;

namespace ReportCenter.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private IConfiguration _configuration;
        public HomeController(ILogger<HomeController> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
        }

        public async ValueTask<IActionResult> Index(string token)
        {
            var baseUrl = this._configuration["URL_API"]; // ระบุ URL ของแอพพลิเคชันของคุณ
            var resource = "api/v1/Menus/ReportList"; // ระบุเส้นทาง API ที่คุณต้องการเรียกใช้
            var client = new RestClient(baseUrl);
            var request = new RestRequest(resource, Method.Get);
            request.AddHeader("Authorization", $"Bearer {token}");
            try
            {
                // ส่งคำขอและรับการตอบกลับจาก API
                var response = await client.ExecuteAsync(request);

                if (response.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    // ดึงข้อมูล JSON ออกมาจากการตอบกลับ
                    var responseData = response.Content;
                    // ดำเนินการกับข้อมูลตามความเหมาะสม
                    Console.WriteLine(responseData);
                }
                else
                {
                    // กรณีเกิดข้อผิดพลาดในการเรียก API
                    Console.WriteLine($"Error: {response.StatusCode}");
                    Console.WriteLine(response.ErrorMessage);
                }
            }
            catch (Exception ex)
            {
                // กรณีเกิดข้อผิดพลาดระหว่างการเรียก API
                Console.WriteLine($"Exception: {ex.Message}");
            }
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}