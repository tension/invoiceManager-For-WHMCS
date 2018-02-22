-- Invoice Manager
-- version 1.0
-- https://neworld.org/

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- 表的结构 `vati_address`
--

CREATE TABLE `vati_address` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `name` text NOT NULL,
  `province` text NOT NULL,
  `address` text NOT NULL,
  `mobile` varchar(32) NOT NULL,
  `phone` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `vati_express`
--

CREATE TABLE `vati_express` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `code` varchar(16) NOT NULL,
  `price` varchar(16) NOT NULL,
  `status` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `vati_express_price`
--

CREATE TABLE `vati_express_price` (
  `id` int(11) NOT NULL,
  `orderby` int(11) NOT NULL,
  `express` int(11) NOT NULL,
  `province` text NOT NULL,
  `price` varchar(16) NOT NULL,
  `status` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `vati_express_record`
--

CREATE TABLE `vati_express_record` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `express` int(11) NOT NULL,
  `name` text NOT NULL,
  `invoice` text NOT NULL,
  `address` text NOT NULL,
  `code` varchar(128) NOT NULL,
  `amount` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `vati_invoice`
--

CREATE TABLE `vati_invoice` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `type` varchar(16) NOT NULL,
  `name` text NOT NULL,
  `invoice` varchar(128) NOT NULL,
  `address` text NOT NULL,
  `amount` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `vati_invoice_record`
--

CREATE TABLE `vati_invoice_record` (
  `id` int(11) NOT NULL,
  `invoice` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 表的结构 `vati_title`
--

CREATE TABLE `vati_title` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `name` text NOT NULL,
  `type` varchar(16) NOT NULL,
  `info_1` text NOT NULL,
  `info_2` text NOT NULL,
  `info_3` text NOT NULL,
  `info_4` text NOT NULL,
  `info_5` text NOT NULL,
  `file` text NOT NULL,
  `remark` text NOT NULL,
  `status` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `vati_address`
--
ALTER TABLE `vati_address`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `vati_express`
--
ALTER TABLE `vati_express`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `vati_express_price`
--
ALTER TABLE `vati_express_price`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `vati_express_record`
--
ALTER TABLE `vati_express_record`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `vati_invoice`
--
ALTER TABLE `vati_invoice`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `vati_invoice_record`
--
ALTER TABLE `vati_invoice_record`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `vati_title`
--
ALTER TABLE `vati_title`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `vati_address`
--
ALTER TABLE `vati_address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- 使用表AUTO_INCREMENT `vati_express`
--
ALTER TABLE `vati_express`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- 使用表AUTO_INCREMENT `vati_express_price`
--
ALTER TABLE `vati_express_price`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- 使用表AUTO_INCREMENT `vati_express_record`
--
ALTER TABLE `vati_express_record`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- 使用表AUTO_INCREMENT `vati_invoice`
--
ALTER TABLE `vati_invoice`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- 使用表AUTO_INCREMENT `vati_title`
--
ALTER TABLE `vati_title`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;