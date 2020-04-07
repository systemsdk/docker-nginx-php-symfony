<?php
declare(strict_types = 1);
/**
 * /src/Service/MessageService.php
 */

namespace App\Service;

use App\Message\TestMessage;
use Symfony\Component\Messenger\Envelope;
use Symfony\Component\Messenger\MessageBusInterface;
use App\Service\Interfaces\MessageServiceInterface;

/**
 * Class MessageService
 *
 * @package App\Service
 */
class MessageService implements MessageServiceInterface
{
    private MessageBusInterface $bus;

    /**
     * Constructor
     *
     * @param MessageBusInterface $bus
     */
    public function __construct(MessageBusInterface $bus)
    {
        $this->bus = $bus;
    }

    /**
     * @inheritDoc
     * TODO: This is example for creating test message, you can delete it.
     */
    public function sendTestMessage(string $someId): self
    {
        $this->bus->dispatch(new Envelope(new TestMessage($someId)));

        return $this;
    }
}
