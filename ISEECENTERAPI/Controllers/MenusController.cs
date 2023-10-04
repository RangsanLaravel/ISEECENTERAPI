using ISEECENTERAPI.BussinessLogic;
using ISEECENTERAPI.DataContract;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Hosting.Internal;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ISEECENTERAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/v1/[controller]")]
    public class MenusController : ControllerBase
    {
        private readonly IConfiguration Configuration = null;
        private readonly ServiceAction service;
        public MenusController(IConfiguration Configuration)
        {           
            this.Configuration = Configuration;          
            this.service = new ServiceAction(this.Configuration.GetConnectionString("ConnectionSQLServer"), Configuration["ConfigSetting:DBENV"]);
            //this.mailService = mailService;
        }

        [AllowAnonymous]
        [HttpPost("Login")]
        public async ValueTask<IActionResult> Login(UserLogin user)
        {
            employee_info employee_Info = null;
            try
            {
                var isNotValid = string.IsNullOrWhiteSpace(user.UserName) || string.IsNullOrWhiteSpace(user.Password);
                if (isNotValid)
                {
                    return NotFound("ไม่พบข้อมูลผู้ใช้งาน");
                }
                employee_Info = await this.service.UserLogin(user);
                if (employee_Info is null)
                {
                    return BadRequest("UserName or Password invalid ");
                }
                else
                {
                    
                    var token = await BuildToken(employee_Info);
                    var application = await this.service.GETAPPLICATION(employee_Info.user_id);
                    employee_Info.token = token;
                    employee_Info.application = new List<tbm_application_center>();
                    employee_Info.application = application;
                    return Ok(employee_Info);
                }
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("CounterCall/{fname}")]
        public async ValueTask<IActionResult> CounterCall(string fname)
        {
            //var userid = User.Claims.Where(a => a.Type == "id").Select(a => a.Value).FirstOrDefault();
            try
            {
                var resutl = await this.service.CounterCall(fname);
                return Ok(resutl);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("GetCounterDetail/{customerID}/{licenseNo}")]
        public async ValueTask<IActionResult> GetCounterDetail(string customerID, string licenseNo)
        {
            if (string.IsNullOrEmpty(customerID)) return BadRequest("customerID กรุณาระบุ");
            if (string.IsNullOrEmpty(licenseNo)) return BadRequest("licenseNo กรุณาระบุ");
            try
            {
                var application = await this.service.GetCounterDetail(customerID,licenseNo);
                return Ok(application);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("ReportList")]
        public async ValueTask<IActionResult> ReportList()
        {          
            try
            {
                var application = await this.service.GET_REPORTCENTER();
                return Ok(application);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        private async ValueTask<string> BuildToken(employee_info employee)
        {
            // key is case-sensitive
            var claims = new[] {
                new Claim(JwtRegisteredClaimNames.Sub, Configuration["Jwt:Subject"]),
                new Claim("id", employee.user_id),
                new Claim("username", employee.user_name),
            //ใช้ role เพื่อลดการโหลดดาต้าเบส
                new Claim(ClaimTypes.Role, employee.position)
            };
            var expires = DateTime.Now.AddDays(Convert.ToDouble(Configuration["Jwt:ExpireDay"]));
            //แก้วันที่ได้
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Jwt:Key"]));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: Configuration["Jwt:Issuer"],
                audience: Configuration["Jwt:Audience"],
                claims: claims,
                expires: expires,
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
