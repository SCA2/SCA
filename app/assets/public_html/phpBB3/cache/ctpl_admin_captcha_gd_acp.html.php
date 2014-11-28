<?php if (!defined('IN_PHPBB')) exit; $this->_tpl_include('overall_header.html'); ?>


<a name="maincontent"></a>
	<a href="<?php echo (isset($this->_rootref['U_ACTION'])) ? $this->_rootref['U_ACTION'] : ''; ?>" style="float: <?php echo (isset($this->_rootref['S_CONTENT_FLOW_END'])) ? $this->_rootref['S_CONTENT_FLOW_END'] : ''; ?>;">&laquo; <?php echo ((isset($this->_rootref['L_BACK'])) ? $this->_rootref['L_BACK'] : ((isset($user->lang['BACK'])) ? $user->lang['BACK'] : '{ BACK }')); ?></a>

<h1><?php echo ((isset($this->_rootref['L_ACP_VC_SETTINGS'])) ? $this->_rootref['L_ACP_VC_SETTINGS'] : ((isset($user->lang['ACP_VC_SETTINGS'])) ? $user->lang['ACP_VC_SETTINGS'] : '{ ACP_VC_SETTINGS }')); ?></h1>

<p><?php echo ((isset($this->_rootref['L_ACP_VC_SETTINGS_EXPLAIN'])) ? $this->_rootref['L_ACP_VC_SETTINGS_EXPLAIN'] : ((isset($user->lang['ACP_VC_SETTINGS_EXPLAIN'])) ? $user->lang['ACP_VC_SETTINGS_EXPLAIN'] : '{ ACP_VC_SETTINGS_EXPLAIN }')); ?></p>


<form id="acp_captcha" method="post" action="<?php echo (isset($this->_rootref['U_ACTION'])) ? $this->_rootref['U_ACTION'] : ''; ?>">

<fieldset>
<legend><?php echo ((isset($this->_rootref['L_GENERAL_OPTIONS'])) ? $this->_rootref['L_GENERAL_OPTIONS'] : ((isset($user->lang['GENERAL_OPTIONS'])) ? $user->lang['GENERAL_OPTIONS'] : '{ GENERAL_OPTIONS }')); ?></legend>

<dl>
	<dt><label for="captcha_gd_foreground_noise"><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_FOREGROUND_NOISE'])) ? $this->_rootref['L_CAPTCHA_GD_FOREGROUND_NOISE'] : ((isset($user->lang['CAPTCHA_GD_FOREGROUND_NOISE'])) ? $user->lang['CAPTCHA_GD_FOREGROUND_NOISE'] : '{ CAPTCHA_GD_FOREGROUND_NOISE }')); ?>:</label><br /><span><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_FOREGROUND_NOISE_EXPLAIN'])) ? $this->_rootref['L_CAPTCHA_GD_FOREGROUND_NOISE_EXPLAIN'] : ((isset($user->lang['CAPTCHA_GD_FOREGROUND_NOISE_EXPLAIN'])) ? $user->lang['CAPTCHA_GD_FOREGROUND_NOISE_EXPLAIN'] : '{ CAPTCHA_GD_FOREGROUND_NOISE_EXPLAIN }')); ?></span></dt>
	<dd><label><input id="captcha_gd_foreground_noise" name="captcha_gd_foreground_noise" value="1" class="radio" type="radio"<?php if ($this->_rootref['CAPTCHA_GD_FOREGROUND_NOISE']) {  ?> checked="checked"<?php } ?> /> <?php echo ((isset($this->_rootref['L_YES'])) ? $this->_rootref['L_YES'] : ((isset($user->lang['YES'])) ? $user->lang['YES'] : '{ YES }')); ?></label>
		<label><input name="captcha_gd_foreground_noise" value="0" class="radio" type="radio"<?php if (! $this->_rootref['CAPTCHA_GD_FOREGROUND_NOISE']) {  ?> checked="checked"<?php } ?> /> <?php echo ((isset($this->_rootref['L_NO'])) ? $this->_rootref['L_NO'] : ((isset($user->lang['NO'])) ? $user->lang['NO'] : '{ NO }')); ?></label></dd>
</dl>
<dl>
	<dt><label for="captcha_gd_x_grid"><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_X_GRID'])) ? $this->_rootref['L_CAPTCHA_GD_X_GRID'] : ((isset($user->lang['CAPTCHA_GD_X_GRID'])) ? $user->lang['CAPTCHA_GD_X_GRID'] : '{ CAPTCHA_GD_X_GRID }')); ?>:</label><br /><span><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_X_GRID_EXPLAIN'])) ? $this->_rootref['L_CAPTCHA_GD_X_GRID_EXPLAIN'] : ((isset($user->lang['CAPTCHA_GD_X_GRID_EXPLAIN'])) ? $user->lang['CAPTCHA_GD_X_GRID_EXPLAIN'] : '{ CAPTCHA_GD_X_GRID_EXPLAIN }')); ?></span></dt>
	<dd><input id="captcha_gd_x_grid" name="captcha_gd_x_grid" value="<?php echo (isset($this->_rootref['CAPTCHA_GD_X_GRID'])) ? $this->_rootref['CAPTCHA_GD_X_GRID'] : ''; ?>" type="text" /></dd>
</dl>
<dl>
	<dt><label for="captcha_gd_y_grid"><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_Y_GRID'])) ? $this->_rootref['L_CAPTCHA_GD_Y_GRID'] : ((isset($user->lang['CAPTCHA_GD_Y_GRID'])) ? $user->lang['CAPTCHA_GD_Y_GRID'] : '{ CAPTCHA_GD_Y_GRID }')); ?>:</label><br /><span><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_Y_GRID_EXPLAIN'])) ? $this->_rootref['L_CAPTCHA_GD_Y_GRID_EXPLAIN'] : ((isset($user->lang['CAPTCHA_GD_Y_GRID_EXPLAIN'])) ? $user->lang['CAPTCHA_GD_Y_GRID_EXPLAIN'] : '{ CAPTCHA_GD_Y_GRID_EXPLAIN }')); ?></span></dt>
	<dd><input id="captcha_gd_y_grid" name="captcha_gd_y_grid" value="<?php echo (isset($this->_rootref['CAPTCHA_GD_Y_GRID'])) ? $this->_rootref['CAPTCHA_GD_Y_GRID'] : ''; ?>" type="text" /></dd>
</dl>
<dl>
	<dt><label for="captcha_gd_wave"><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_WAVE'])) ? $this->_rootref['L_CAPTCHA_GD_WAVE'] : ((isset($user->lang['CAPTCHA_GD_WAVE'])) ? $user->lang['CAPTCHA_GD_WAVE'] : '{ CAPTCHA_GD_WAVE }')); ?>:</label><br /><span><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_WAVE_EXPLAIN'])) ? $this->_rootref['L_CAPTCHA_GD_WAVE_EXPLAIN'] : ((isset($user->lang['CAPTCHA_GD_WAVE_EXPLAIN'])) ? $user->lang['CAPTCHA_GD_WAVE_EXPLAIN'] : '{ CAPTCHA_GD_WAVE_EXPLAIN }')); ?></span></dt>
	<dd><label><input id="captcha_gd_wave" name="captcha_gd_wave" value="1" class="radio" type="radio"<?php if ($this->_rootref['CAPTCHA_GD_WAVE']) {  ?> checked="checked"<?php } ?> /> <?php echo ((isset($this->_rootref['L_YES'])) ? $this->_rootref['L_YES'] : ((isset($user->lang['YES'])) ? $user->lang['YES'] : '{ YES }')); ?></label>
		<label><input name="captcha_gd_wave" value="0" class="radio" type="radio"<?php if (! $this->_rootref['CAPTCHA_GD_WAVE']) {  ?> checked="checked"<?php } ?> /> <?php echo ((isset($this->_rootref['L_NO'])) ? $this->_rootref['L_NO'] : ((isset($user->lang['NO'])) ? $user->lang['NO'] : '{ NO }')); ?></label>
</dd>
</dl>
<dl>
	<dt><label for="captcha_gd_3d_noise"><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_3D_NOISE'])) ? $this->_rootref['L_CAPTCHA_GD_3D_NOISE'] : ((isset($user->lang['CAPTCHA_GD_3D_NOISE'])) ? $user->lang['CAPTCHA_GD_3D_NOISE'] : '{ CAPTCHA_GD_3D_NOISE }')); ?>:</label><br /><span><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_3D_NOISE_EXPLAIN'])) ? $this->_rootref['L_CAPTCHA_GD_3D_NOISE_EXPLAIN'] : ((isset($user->lang['CAPTCHA_GD_3D_NOISE_EXPLAIN'])) ? $user->lang['CAPTCHA_GD_3D_NOISE_EXPLAIN'] : '{ CAPTCHA_GD_3D_NOISE_EXPLAIN }')); ?></span></dt>
	<dd><label><input id="captcha_gd_3d_noise" name="captcha_gd_3d_noise" value="1" class="radio" type="radio"<?php if ($this->_rootref['CAPTCHA_GD_3D_NOISE']) {  ?> checked="checked"<?php } ?> /> <?php echo ((isset($this->_rootref['L_YES'])) ? $this->_rootref['L_YES'] : ((isset($user->lang['YES'])) ? $user->lang['YES'] : '{ YES }')); ?></label>
		<label><input name="captcha_gd_3d_noise" value="0" class="radio" type="radio"<?php if (! $this->_rootref['CAPTCHA_GD_3D_NOISE']) {  ?> checked="checked"<?php } ?> /> <?php echo ((isset($this->_rootref['L_NO'])) ? $this->_rootref['L_NO'] : ((isset($user->lang['NO'])) ? $user->lang['NO'] : '{ NO }')); ?></label>
</dd>
</dl>
<dl>
	<dt><label for="captcha_gd_fonts"><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_FONTS'])) ? $this->_rootref['L_CAPTCHA_GD_FONTS'] : ((isset($user->lang['CAPTCHA_GD_FONTS'])) ? $user->lang['CAPTCHA_GD_FONTS'] : '{ CAPTCHA_GD_FONTS }')); ?>:</label><br /><span><?php echo ((isset($this->_rootref['L_CAPTCHA_GD_FONTS_EXPLAIN'])) ? $this->_rootref['L_CAPTCHA_GD_FONTS_EXPLAIN'] : ((isset($user->lang['CAPTCHA_GD_FONTS_EXPLAIN'])) ? $user->lang['CAPTCHA_GD_FONTS_EXPLAIN'] : '{ CAPTCHA_GD_FONTS_EXPLAIN }')); ?></span></dt>
	<dd><label><input id="captcha_gd_fonts" name="captcha_gd_fonts" value="1" class="radio" type="radio"<?php if ($this->_rootref['CAPTCHA_GD_FONTS'] == (1)) {  ?> checked="checked"<?php } ?> /> <?php echo ((isset($this->_rootref['L_CAPTCHA_FONT_DEFAULT'])) ? $this->_rootref['L_CAPTCHA_FONT_DEFAULT'] : ((isset($user->lang['CAPTCHA_FONT_DEFAULT'])) ? $user->lang['CAPTCHA_FONT_DEFAULT'] : '{ CAPTCHA_FONT_DEFAULT }')); ?></label>
		<label><input name="captcha_gd_fonts" value="2" class="radio" type="radio"<?php if ($this->_rootref['CAPTCHA_GD_FONTS'] == (2)) {  ?> checked="checked"<?php } ?> /> <?php echo ((isset($this->_rootref['L_CAPTCHA_FONT_NEW'])) ? $this->_rootref['L_CAPTCHA_FONT_NEW'] : ((isset($user->lang['CAPTCHA_FONT_NEW'])) ? $user->lang['CAPTCHA_FONT_NEW'] : '{ CAPTCHA_FONT_NEW }')); ?></label>
		<label><input name="captcha_gd_fonts" value="3" class="radio" type="radio"<?php if ($this->_rootref['CAPTCHA_GD_FONTS'] == (3)) {  ?> checked="checked"<?php } ?> /> <?php echo ((isset($this->_rootref['L_CAPTCHA_FONT_LOWER'])) ? $this->_rootref['L_CAPTCHA_FONT_LOWER'] : ((isset($user->lang['CAPTCHA_FONT_LOWER'])) ? $user->lang['CAPTCHA_FONT_LOWER'] : '{ CAPTCHA_FONT_LOWER }')); ?></label>

</dd>
</dl>

</fieldset>
<fieldset>
	<legend><?php echo ((isset($this->_rootref['L_PREVIEW'])) ? $this->_rootref['L_PREVIEW'] : ((isset($user->lang['PREVIEW'])) ? $user->lang['PREVIEW'] : '{ PREVIEW }')); ?></legend>
	<?php if ($this->_rootref['CAPTCHA_PREVIEW']) {  if (isset($this->_rootref['CAPTCHA_PREVIEW'])) { $this->_tpl_include($this->_rootref['CAPTCHA_PREVIEW']); } } ?>


</fieldset>

<fieldset>
	<legend><?php echo ((isset($this->_rootref['L_ACP_SUBMIT_CHANGES'])) ? $this->_rootref['L_ACP_SUBMIT_CHANGES'] : ((isset($user->lang['ACP_SUBMIT_CHANGES'])) ? $user->lang['ACP_SUBMIT_CHANGES'] : '{ ACP_SUBMIT_CHANGES }')); ?></legend>
	<p class="submit-buttons">
		<input class="button1" type="submit" id="submit" name="submit" value="<?php echo ((isset($this->_rootref['L_SUBMIT'])) ? $this->_rootref['L_SUBMIT'] : ((isset($user->lang['SUBMIT'])) ? $user->lang['SUBMIT'] : '{ SUBMIT }')); ?>" />&nbsp;
		<input class="button2" type="reset" id="reset" name="reset" value="<?php echo ((isset($this->_rootref['L_RESET'])) ? $this->_rootref['L_RESET'] : ((isset($user->lang['RESET'])) ? $user->lang['RESET'] : '{ RESET }')); ?>" />&nbsp;
		<input class="button2" type="submit" id="preview" name="preview" value="<?php echo ((isset($this->_rootref['L_PREVIEW'])) ? $this->_rootref['L_PREVIEW'] : ((isset($user->lang['PREVIEW'])) ? $user->lang['PREVIEW'] : '{ PREVIEW }')); ?>" />&nbsp;
	</p>

	<input type="hidden" name="select_captcha" value="<?php echo (isset($this->_rootref['CAPTCHA_NAME'])) ? $this->_rootref['CAPTCHA_NAME'] : ''; ?>" />
	<input type="hidden" name="configure" value="1" />

	<?php echo (isset($this->_rootref['S_FORM_TOKEN'])) ? $this->_rootref['S_FORM_TOKEN'] : ''; ?>

</fieldset>
</form>

<?php $this->_tpl_include('overall_footer.html'); ?>