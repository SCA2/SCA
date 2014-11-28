<?php if (!defined('IN_PHPBB')) exit; $this->_tpl_include('simple_header.html'); ?>


<script type="text/javascript">
// <![CDATA[
/**
* Jump to inbox
*/
function jump_to_inbox(url)
{
	opener.document.location.href = url.replace(/&amp;/g, '&');
	window.close();
}
// ]]>
</script>

<div class="panel">
	<div class="inner"><span class="corners-top"><span></span></span>
	<div class="content">
		<p><?php if ($this->_rootref['S_NOT_LOGGED_IN']) {  echo ((isset($this->_rootref['L_LOGIN_CHECK_PM'])) ? $this->_rootref['L_LOGIN_CHECK_PM'] : ((isset($user->lang['LOGIN_CHECK_PM'])) ? $user->lang['LOGIN_CHECK_PM'] : '{ LOGIN_CHECK_PM }')); } else { echo (isset($this->_rootref['MESSAGE'])) ? $this->_rootref['MESSAGE'] : ''; ?><br /><br /><?php echo (isset($this->_rootref['CLICK_TO_VIEW'])) ? $this->_rootref['CLICK_TO_VIEW'] : ''; } ?></p>
		<p class="small"><a href="#" onclick="window.close(); return false;"><?php echo ((isset($this->_rootref['L_CLOSE_WINDOW'])) ? $this->_rootref['L_CLOSE_WINDOW'] : ((isset($user->lang['CLOSE_WINDOW'])) ? $user->lang['CLOSE_WINDOW'] : '{ CLOSE_WINDOW }')); ?></a></p>
	</div>
	<span class="corners-bottom"><span></span></span></div>
</div>

<?php $this->_tpl_include('simple_footer.html'); ?>