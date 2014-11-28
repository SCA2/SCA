<?php if (!defined('IN_PHPBB')) exit; ?>Subject: Reactivate your account

Hello <?php echo (isset($this->_rootref['USERNAME'])) ? $this->_rootref['USERNAME'] : ''; ?>,

Your account on "<?php echo (isset($this->_rootref['SITENAME'])) ? $this->_rootref['SITENAME'] : ''; ?>" has been deactivated, most likely due to changes made to your profile. In order to reactivate your account you must click on the link below:

<?php echo (isset($this->_rootref['U_ACTIVATE'])) ? $this->_rootref['U_ACTIVATE'] : ''; ?>


<?php echo (isset($this->_rootref['EMAIL_SIG'])) ? $this->_rootref['EMAIL_SIG'] : ''; ?>