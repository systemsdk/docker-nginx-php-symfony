<?php
declare(strict_types=1);

namespace App\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase as BaseTestCase;

abstract class FunctionalTestCase extends BaseTestCase
{
    use CreatesApplication;
}
