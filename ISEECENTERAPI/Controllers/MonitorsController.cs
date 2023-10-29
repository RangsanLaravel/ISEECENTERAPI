using ISEECENTERAPI.BussinessLogic;
using ISEECENTERAPI.DataContract;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ISEECENTERAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MonitorsController : ControllerBase
    {
        private readonly IConfiguration Configuration = null;
        private readonly ServiceAction service;
        public MonitorsController(IConfiguration Configuration)
        {
            this.Configuration = Configuration;
            this.service = new ServiceAction(this.Configuration.GetConnectionString("ConnectionSQLServer"), Configuration["ConfigSetting:DBENV"]);
            //this.mailService = mailService;
        }
        [HttpPost("GET_DETAIL_ALLJOB")]
        public async ValueTask<IActionResult> GET_DETAIL_ALLJOB(searchalljob data)
        {
            try
            {
                var application = await this.service.GET_DETAIL_ALLJOB(data);
                return Ok(application);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [Authorize]
        [HttpGet("GET_ALL_OWNER")]
        public async ValueTask<IActionResult> GET_ALL_OWNER()
        {
            try
            {
                var result = await this.service.GET_ALL_OWNER();
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
    }
}
