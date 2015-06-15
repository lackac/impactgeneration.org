<?

class ContactForm {

  protected $organization = 'IMPACT generation';
  protected $senderMail   = 'info@impactgeneration.org';
  protected $infoMail     = 'info@impactgeneration.org';

  protected $subject = array(
    'visitor' => 'Thank you for your question',
    'impact'  => 'New question through the website from '
  );

  protected $returnMessageOnSuccess = 'Thank you for contacting us!';

  protected $error = array();

  /**
   * POST fields
   */
  protected $email;
  protected $question;
  protected $honeypot;

  public function __construct($email, $question, $honeypot) {
    $this->email    = $email;
    $this->question = $question;
    $this->honeypot = $honeypot;
  }

  public function send() {
    if ($this->isValid()) {
      $this->sendMail($this->email, $this->subject['visitor'], $this->emailBody('visitor'));
      $this->sendMail($this->infoMail, $this->subject['impact'].$this->email, $this->emailBody('impact'));

      return $this->getSuccess();
    }

    return $this->getError();
  }

  protected function isValid() {
    if (!!$this->honeypot) {
      return false;
    }

    if (!$this->email || !preg_match("/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/", $this->email)) {
      $this->error['email'] = "Provide a valid email address!";
    }

    if (!$this->question || !strip_tags($this->question)) {
      $this->error['question'] = "What was it that you wanted to ask?";
    }

    return (bool)(!count($this->error));
  }

  protected function getSuccess() {
    return json_encode(array('ok' => $this->returnMessageOnSuccess));
  }

  protected function getError() {
    return json_encode($this->error);
  }

  protected function emailBody($type)
  {
    if ($type == 'visitor') {
      return nl2br("
Dear Brother/Sister!

Thank you for contacting us! We have received the following question from you:

<i>".strip_tags($this->question)."</i>

We try our best to answer your question as soon as possible.

Blessings,
IMPACT generation
      ");
    }

    return nl2br("
A new question has just arrived through the www.impactgeneration.org website. Reply to this email to answer it or forward it to the right person.

The question was:

<i>".strip_tags($this->question)."</i>

The sender email address: ".$this->email."
    ");
  }

  protected function sendMail($target, $subject, $body)
  {
    $replyToMail = ($this->email == $target) ? $this->infoMail : $this->email;

    $header = '';
    $header .= "MIME-Version: 1.0"."\r\n";
    $header .= 'Content-Transfer-Encoding: 8bit'."\r\n";
    $header .= 'Content-type: text/html; charset="utf-8"'."\r\n";
    $header .= 'Return-Path: '.$this->senderMail."\r\n";
    $header .= 'From: '.$this->organization.' <'.$this->senderMail.">\r\n";
    $header .= 'Reply-To: '.$replyToMail."\r\n";
    $header .= "X-Sender: <".$this->senderMail.">\r\n";
    $header .= "X-Mailer: PHP"."\r\n";
    $header .= "X-Priority: 2"."\r\n";
    ini_set('sendmail_from', $this->senderMail);

    return mail($target, $subject, $body, $header, "-oi -f ".$this->senderMail);
  }

}

$contactForm = new ContactForm(
  isset($_POST['email'])    ? $_POST['email']    : '',
  isset($_POST['question']) ? $_POST['question'] : '',
  isset($_POST['d_subject']) ? $_POST['d_subject'] : ''
);

echo $contactForm->send();
