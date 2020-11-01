<?php
declare(strict_types = 1);
/**
 * /src/MessageHandler/TestHandler.php
 */

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
    private LoggerInterface $logger;

    /**
     * Constructor
     */
    public function __construct(LoggerInterface $logger)
    {
        $this->logger = $logger;
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
     *
     * @phpcsSuppress SlevomatCodingStandard.Functions.UnusedParameter
     */
    private function handleMessage(TestMessage $message): void
    {
        // some actions here
        $this->logger->info('Test message processed');
    }
}
