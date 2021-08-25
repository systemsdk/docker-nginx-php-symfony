<?php

declare(strict_types=1);

namespace App\MessageHandler;

use App\Message\TestMessage;
use Psr\Log\LoggerInterface;
use Symfony\Component\Messenger\Handler\MessageSubscriberInterface;
use Throwable;

/**
 * Class TestHandler
 * TODO: This is handler example, you can delete it.
 *
 * @package App\MessageHandler
 */
class TestHandler implements MessageSubscriberInterface
{
    public function __construct(
        private LoggerInterface $logger,
    ) {
    }

    /**
     * @throws Throwable
     */
    public function __invoke(TestMessage $message): void
    {
        $this->handleMessage($message);
    }

    /**
     * {@inheritdoc}
     *
     * @phpstan-return iterable<int, string>
     */
    public static function getHandledMessages(): iterable
    {
        // handle this message on __invoke
        yield TestMessage::class;

        /*yield ...Message::class => [
            'method' => 'handle...',
        ];*/
    }

    /**
     * @throws Throwable
     */
    private function handleMessage(TestMessage $message): void
    {
        $id = $message->getSomeId();
        // some actions here
        $this->logger->info('Test message processed with id: ' . $id);
    }
}
