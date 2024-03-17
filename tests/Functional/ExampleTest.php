<?php

declare(strict_types=1);

namespace App\Tests\Functional;

use App\Tests\FunctionalTestCase;
use Throwable;

/**
 * @package App\Tests\Functional
 */
class ExampleTest extends FunctionalTestCase
{
    /**
     * A basic test example.
     *
     * @throws Throwable
     */
    public function testBasicTest(): void
    {
        $client = static::createClient();
        $client->request('GET', '/command-scheduler/list');
        // check for 401 due to allow only for user with admin role
        static::assertSame(401, $client->getResponse()->getStatusCode());
    }
}
