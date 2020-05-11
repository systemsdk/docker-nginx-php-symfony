<?php
declare(strict_types = 1);

namespace App\MessageHandler;

use App\Message\TestMessage;
use Symfony\Component\Messenger\Handler\MessageSubscriberInterface;
use Psr\Log\LoggerInterface;
use Throwable;

/**
 * Class TestHandler
 * TODO: This is handler example, you can delete it.
 *
 * @package App\MessageHandler
 */
class TestHandler implements MessageSubscriberInterface
{
    private LoggerInterface $logger;

    /**
     * Constructor
     *
     * @param LoggerInterface $logger
     */
    public function __construct(LoggerInterface $logger)
    {
        $this->logger = $logger;
    }

    /**
     * @param TestMessage $message
     *
     * @throws Throwable
     */
    public function __invoke(TestMessage $message): void
    {
        $this->handleMessage($message);
    }

    /**
     * @inheritDoc
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
     * @param TestMessage $message
     *
     * @throws Throwable
     */
    private function handleMessage(TestMessage $message): void
    {
        // some actions here
        $this->logger->info('Test message processed');
    }
}
