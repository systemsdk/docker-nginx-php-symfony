<?php

declare(strict_types=1);

namespace App\Service;

use App\Message\TestMessage;
use App\Service\Interfaces\MessageServiceInterface;
use Symfony\Component\Messenger\Envelope;
use Symfony\Component\Messenger\MessageBusInterface;

/**
 * @package App\Service
 */
class MessageService implements MessageServiceInterface
{
    /**
     * Constructor
     */
    public function __construct(
        private readonly MessageBusInterface $bus
    ) {
    }

    /**
     * TODO: This is example for creating test message, you can delete it.
     */
    public function sendTestMessage(string $someId): self
    {
        $this->bus->dispatch(new Envelope(new TestMessage($someId)));

        return $this;
    }
}
