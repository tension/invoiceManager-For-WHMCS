<?php
!defined('WHMCS') AND die('Access denied.');

add_hook('ClientAreaPrimaryNavbar', 1, function ( $primaryNavbar )
{

    $primaryNavbar->addChild('发票管理')->setOrder(40);
    $invoces = $primaryNavbar->getChild('发票管理');
	$invoces->addChild('申请发票',
            array(
                'uri' => 'index.php?m=invoiceManager',
                'order' => 1,
                'icon' => 'fa-check-square fa-fw',
            )
        );
	$invoces->addChild('发票列表',
        array(
            'uri' => 'index.php?m=invoiceManager&page=invoice',
            'order' => 2,
            'icon' => 'fa-list fa-fw',
        )
    );
	$invoces->addChild('快递列表',
        array(
            'uri' => 'index.php?m=invoiceManager&page=express',
            'order' => 3,
			'icon' => 'fa-plane fa-fw',
        )
    );
	$invoces->addChild('抬头管理',
        array(
            'uri' => 'index.php?m=invoiceManager&page=title',
            'order' => 4,
            'icon' => 'fa-briefcase fa-fw',
        )
    );
	$invoces->addChild('地址管理',
        array(
            'uri' => 'index.php?m=invoiceManager&page=address',
            'order' => 5,
            'icon' => 'fa-user fa-fw',
        )
    );
});