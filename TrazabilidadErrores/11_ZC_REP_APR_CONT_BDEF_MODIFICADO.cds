projection;
strict ( 2 );

define behavior for ZC_REP_APR_CONT
use etag
{
  use action display_attachment;
  use action display_deny_text;
  use action display_observations;
  use action display_text;
  use action display_errors;   // NUEVO
}
