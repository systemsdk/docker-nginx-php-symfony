<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20190222213409 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->abortIf(
            $this->connection->getDatabasePlatform()->getName() !== 'mysql',
            'Migration can only be executed safely on \'mysql\'.'
        );

        $sql = <<<SQL
CREATE TABLE scheduled_command (
    id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(100) NOT NULL,
    command VARCHAR(100) NOT NULL,
    arguments LONGTEXT DEFAULT NULL,
    cron_expression VARCHAR(100) DEFAULT NULL,
    last_execution DATETIME NOT NULL,
    last_return_code INT DEFAULT NULL,
    log_file VARCHAR(100) DEFAULT NULL,
    priority INT NOT NULL,
    execute_immediately TINYINT(1) NOT NULL,
    disabled TINYINT(1) NOT NULL,
    locked TINYINT(1) NOT NULL,
    PRIMARY KEY(id)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ENGINE = InnoDB
SQL;

        $this->addSql($sql);
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->abortIf(
            $this->connection->getDatabasePlatform()->getName() !== 'mysql',
            'Migration can only be executed safely on \'mysql\'.'
        );

        $this->addSql('DROP TABLE scheduled_command');
    }
}
