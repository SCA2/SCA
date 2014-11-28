<?php if (!defined('IN_PHPBB')) exit; if ($this->_rootref['S_TYPE'] == (1)) {  ?>

<div class="panel">
	<div class="inner"><span class="corners-top"><span></span></span>

	<h3><?php echo ((isset($this->_rootref['L_CONFIRMATION'])) ? $this->_rootref['L_CONFIRMATION'] : ((isset($user->lang['CONFIRMATION'])) ? $user->lang['CONFIRMATION'] : '{ CONFIRMATION }')); ?></h3>
	<fieldset class="fields2">
<?php } ?>


	<dl>
	<dt><label><?php echo (isset($this->_rootref['QA_CONFIRM_QUESTION'])) ? $this->_rootref['QA_CONFIRM_QUESTION'] : ''; ?>:</label><br /><span><?php echo ((isset($this->_rootref['L_CONFIRM_QUESTION_EXPLAIN'])) ? $this->_rootref['L_CONFIRM_QUESTION_EXPLAIN'] : ((isset($user->lang['CONFIRM_QUESTION_EXPLAIN'])) ? $user->lang['CONFIRM_QUESTION_EXPLAIN'] : '{ CONFIRM_QUESTION_EXPLAIN }')); ?></span></dt>
	<dd>
		<input type="text" tabindex="<?php echo (isset($this->_tpldata['DEFINE']['.']['CAPTCHA_TAB_INDEX'])) ? $this->_tpldata['DEFINE']['.']['CAPTCHA_TAB_INDEX'] : ''; ?>" name="qa_answer" id="answer" size="45"  class="inputbox autowidth" title="<?php echo ((isset($this->_rootref['L_ANSWER'])) ? $this->_rootref['L_ANSWER'] : ((isset($user->lang['ANSWER'])) ? $user->lang['ANSWER'] : '{ ANSWER }')); ?>" />
		<input type="hidden" name="qa_confirm_id" id="qa_confirm_id" value="<?php echo (isset($this->_rootref['QA_CONFIRM_ID'])) ? $this->_rootref['QA_CONFIRM_ID'] : ''; ?>" />
	</dd>
	</dl>

<?php if ($this->_rootref['S_TYPE'] == (1)) {  ?>

	</fieldset>
	<span class="corners-bottom"><span></span></span></div>
</div>
<?php } ?>