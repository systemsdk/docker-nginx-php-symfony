<?php

declare(strict_types=1);

namespace App\Message;

use App\Message\Interfaces\MessageHighInterface;

/**
 * Class TestMessage
 * TODO: This is message example, you can delete it.
 *
 * @package App\Message
 */
class TestMessage implements MessageHighInterface
{
    private string $someId;

    public function __construct(string $someId)
    {
        $this->someId = $someId;
    }

    public function getSomeId(): string
    {
        return $this->someId;
    }
}
